use crate::common::*;

use std::time::{SystemTime, UNIX_EPOCH};

const SEARCH_URL_TEMPLATE: &str = "https://github.com/search?q=filename%3Ajustfile&type=Code";

const DELAY: Duration = Duration::from_secs(10);

fn search_url(page: u64) -> String {
  format!("{}&p={}", SEARCH_URL_TEMPLATE, page)
}

pub(crate) fn search(user_session: String) -> Result<(), Error> {
  let mut headers = HeaderMap::new();

  headers.insert(COOKIE, format!("user_session={}", user_session).parse()?);

  let a_href = Selector::parse("a[href]").unwrap();

  let re = Regex::new(
    r"(?ix)
    ^
    /(?P<user>[^/]+)
    /(?P<repo>[^/]+)
    /blob
    /(?P<hash>[0-9a-f]{40})
    (?P<path>.*/justfile)
    $
    ",
  )
  .unwrap();

  let client = Client::builder().default_headers(headers).build()?;

  let timestamp = SystemTime::now()
    .duration_since(UNIX_EPOCH)
    .unwrap()
    .as_secs();

  let search_dir = Path::new("search").join(timestamp.to_string());

  fs::create_dir_all(&search_dir)?;

  for page in 1.. {
    let start = Instant::now();

    eprint!("Requesting page {}... ", page);
    let search_url = search_url(page);
    let response = client.get(&search_url).send()?;
    let status = response.status();
    let body = response.text()?;

    if status == 404 {
      break;
    }

    if !status.is_success() {
      eprintln!("Request failed: {}", status);
      eprintln!("{}", body);
      return Err(status.into());
    }

    let html = Html::parse_document(&body);

    let mut hits = BTreeSet::new();

    for a in html.select(&a_href) {
      let value = a.value().attr("href").unwrap();

      if let Some(captures) = re.captures(value) {
        let hit = Hit {
          user: captures.name("user").unwrap().as_str().to_owned(),
          repo: captures.name("repo").unwrap().as_str().to_owned(),
          hash: captures.name("hash").unwrap().as_str().to_owned(),
          path: captures.name("path").unwrap().as_str().to_owned(),
        };

        hits.insert(hit);
      }
    }

    eprintln!("{} hits", hits.len());

    if hits.is_empty() {
      return Err(Error::Empty);
    }

    let serialized = serde_yaml::to_string(&hits.into_iter().collect::<Vec<Hit>>()).unwrap();

    let path = search_dir.join(&format!("{}.yaml", page));

    fs::write(path, &serialized).unwrap();

    let end = Instant::now();

    if start + DELAY > end {
      thread::sleep(DELAY);
    }
  }

  Ok(())
}
