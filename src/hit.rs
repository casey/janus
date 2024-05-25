use super::*;

#[derive(Debug, Serialize, Deserialize, Ord, PartialOrd, Eq, PartialEq)]
pub(crate) struct Hit {
  pub user: String,
  pub repo: String,
  pub hash: String,
  pub path: String,
}

impl Hit {
  pub(crate) fn load_search_dir() -> Result<BTreeSet<Hit>, Error> {
    let mut hits = BTreeSet::new();

    for result in glob("search/*/*.yaml")? {
      let path = result?;

      let text = fs::read_to_string(path)?;

      let page_hits = serde_yaml::from_str::<Vec<Hit>>(&text)?;

      hits.extend(page_hits.into_iter());
    }

    Ok(hits)
  }
}
