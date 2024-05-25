use {
  super::*,
  reqwest::blocking::Client,
  reqwest::header::{ACCEPT, AUTHORIZATION, USER_AGENT},
  std::{
    thread,
    time::{SystemTime, UNIX_EPOCH},
  },
};

#[derive(Debug, Deserialize)]
struct Results {
  items: Vec<Item>,
}

#[derive(Debug, Deserialize)]
struct Item {
  sha: String,
  repository: Repository,
  path: String,
}

#[derive(Debug, Deserialize)]
struct Repository {
  name: String,
  owner: Owner,
}

#[derive(Debug, Deserialize)]
struct Owner {
  login: String,
}

pub(crate) fn search() -> Result<(), Error> {
  let client = Client::new();

  let mut hits = Vec::new();

  for page in 0.. {
    let response = client
      .get(format!(
        "https://api.github.com/search/code?q=filename:justfile&per_page=100&page={page}",
      ))
      .header(ACCEPT, "application/vnd.github+json")
      .header(AUTHORIZATION, "Bearer TOKEN")
      .header("X-GitHub-Api-Version", "2022-11-28")
      .header(USER_AGENT, "janus")
      .send()?;

    if !response.status().is_success() {
      return Err(
        format!(
          "Request failed with status {}\n{}",
          response.status(),
          response.text()?,
        )
        .into(),
      );
    };

    let results: Results = serde_json::from_str(&response.text()?)?;

    eprintln!("page {page}: {} hits", results.items.len());

    if results.items.is_empty() {
      break;
    }

    hits.extend(results.items.into_iter().map(|item| Hit {
      user: item.repository.owner.login,
      repo: item.repository.name,
      hash: item.sha,
      path: item.path,
    }));

    thread::sleep(Duration::from_secs(10));
  }

  if hits.is_empty() {
    return Err("no results".into());
  }

  let timestamp = SystemTime::now()
    .duration_since(UNIX_EPOCH)
    .unwrap()
    .as_secs();

  fs::create_dir_all("search")?;

  let path = Path::new("search").join(format!("{timestamp}.yaml"));

  let file = File::create(path)?;

  serde_yaml::to_writer(file, &hits)?;

  Ok(())
}
