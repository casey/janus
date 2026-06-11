use crate::common::*;

use std::time::{SystemTime, UNIX_EPOCH};

const DELAY: Duration = Duration::from_secs(7);
const MAX_RESULTS: u64 = 1000;
const MAX_SIZE: u64 = 400_000;
const PER_PAGE: u64 = 100;
const QUERIES: &[&str] = &["filename:justfile", "language:just"];

#[derive(Deserialize)]
struct Results {
  total_count: u64,
  items: Vec<Item>,
}

#[derive(Deserialize)]
struct Item {
  html_url: String,
}

pub(crate) fn search(token: Option<String>) -> Result<(), Error> {
  Searcher::new(token)?.run()
}

struct Searcher {
  client: Client,
  last: Option<Instant>,
  output: u64,
  regex: Regex,
  search_dir: PathBuf,
}

impl Searcher {
  fn token(token: Option<String>) -> Result<String, Error> {
    if let Some(token) = token {
      return Ok(token);
    }

    if let Ok(token) = env::var("GITHUB_TOKEN") {
      return Ok(token);
    }

    let output = process::Command::new("gh")
      .args(["auth", "token"])
      .output()?;

    if !output.status.success() {
      return Err(Error::Token);
    }

    Ok(String::from_utf8_lossy(&output.stdout).trim().to_owned())
  }

  fn new(token: Option<String>) -> Result<Self, Error> {
    let token = Self::token(token)?;

    let mut headers = HeaderMap::new();
    headers.insert(AUTHORIZATION, format!("Bearer {}", token).parse()?);
    headers.insert(ACCEPT, "application/vnd.github+json".parse()?);

    let client = Client::builder()
      .user_agent("janus")
      .default_headers(headers)
      .build()?;

    let timestamp = SystemTime::now()
      .duration_since(UNIX_EPOCH)
      .unwrap()
      .as_secs();

    let search_dir = Path::new("search").join(timestamp.to_string());

    fs::create_dir_all(&search_dir)?;

    let regex = Regex::new(
      r"(?ix)
      ^
      https://github\.com
      /(?P<user>[^/]+)
      /(?P<repo>[^/]+)
      /blob
      /(?P<hash>[0-9a-f]{40})
      (?P<path>/.*)
      $
      ",
    )
    .unwrap();

    Ok(Self {
      client,
      last: None,
      output: 0,
      regex,
      search_dir,
    })
  }

  fn run(&mut self) -> Result<(), Error> {
    for query in QUERIES {
      let mut ranges = vec![(0, MAX_SIZE)];

      while let Some((lo, hi)) = ranges.pop() {
        let results = self.query(query, lo, hi, 1)?;

        eprintln!(
          "{} size:{}..{}: {} results",
          query, lo, hi, results.total_count
        );

        if results.total_count > MAX_RESULTS && lo < hi {
          let mid = lo + (hi - lo) / 2;
          ranges.push((mid + 1, hi));
          ranges.push((lo, mid));
          continue;
        }

        if results.total_count > MAX_RESULTS {
          eprintln!(
            "warning: only {} of {} results for {} size:{}..{} are retrievable",
            MAX_RESULTS, results.total_count, query, lo, hi,
          );
        }

        self.save(&results)?;

        let pages = results.total_count.min(MAX_RESULTS).div_ceil(PER_PAGE);

        for page in 2..=pages {
          let results = self.query(query, lo, hi, page)?;
          self.save(&results)?;
        }
      }
    }

    Ok(())
  }

  fn query(&mut self, query: &str, lo: u64, hi: u64, page: u64) -> Result<Results, Error> {
    let url = format!(
      "https://api.github.com/search/code?q={}+size:{}..{}&per_page={}&page={}",
      query, lo, hi, PER_PAGE, page,
    );

    loop {
      if let Some(last) = self.last {
        let elapsed = last.elapsed();
        if elapsed < DELAY {
          thread::sleep(DELAY - elapsed);
        }
      }

      self.last = Some(Instant::now());

      let response = self.client.get(&url).send()?;

      let status = response.status();

      let retry_after = response
        .headers()
        .get("retry-after")
        .and_then(|value| value.to_str().ok())
        .and_then(|value| value.parse().ok());

      let exhausted = response
        .headers()
        .get("x-ratelimit-remaining")
        .and_then(|value| value.to_str().ok())
        == Some("0");

      if status == 429 || (status == 403 && (retry_after.is_some() || exhausted)) {
        let seconds = retry_after.unwrap_or(60);
        eprintln!("rate limited, sleeping {} seconds...", seconds);
        thread::sleep(Duration::from_secs(seconds));
        continue;
      }

      if !status.is_success() {
        eprintln!("request failed: {}", status);
        eprintln!("{}", response.text()?);
        return Err(status.into());
      }

      return Ok(response.json()?);
    }
  }

  fn save(&mut self, results: &Results) -> Result<(), Error> {
    let mut hits = BTreeSet::new();

    for item in &results.items {
      if let Some(captures) = self.regex.captures(&item.html_url) {
        let path = captures.name("path").unwrap().as_str();

        let name = path.rsplit('/').next().unwrap().to_lowercase();

        if name != "justfile" && name != ".justfile" && !name.ends_with(".just") {
          continue;
        }

        hits.insert(Hit {
          user: captures.name("user").unwrap().as_str().to_owned(),
          repo: captures.name("repo").unwrap().as_str().to_owned(),
          hash: captures.name("hash").unwrap().as_str().to_owned(),
          path: path.to_owned(),
        });
      }
    }

    eprintln!("{} hits", hits.len());

    if hits.is_empty() {
      return Ok(());
    }

    let serialized = serde_yaml::to_string(&hits.into_iter().collect::<Vec<Hit>>()).unwrap();

    fs::write(
      self.search_dir.join(format!("{}.yaml", self.output)),
      serialized,
    )?;

    self.output += 1;

    Ok(())
  }
}
