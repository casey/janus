use crate::common::*;

fn fetch_url(hit: &Hit) -> String {
  format!(
    "https://raw.githubusercontent.com/{}/{}/{}{}",
    hit.user, hit.repo, hit.hash, hit.path
  )
}

pub(crate) fn fetch() -> Result<(), Error> {
  let mut hits = BTreeSet::new();

  for result in glob("search/*/*.yaml")? {
    let path = result?;

    let text = fs::read_to_string(path)?;

    let page_hits: Vec<Hit> = serde_yaml::from_str(&text)?;

    hits.extend(page_hits.into_iter());
  }

  eprintln!("Fetching {} hits...", hits.len());

  let fetch_dir = Path::new("fetch");

  fs::create_dir_all(fetch_dir)?;

  let mut new = 0;

  for hit in &hits {
    let url = fetch_url(hit);
    eprint!("/{}/{}{}... ", hit.user, hit.repo, hit.path);

    match reqwest::get(&url) {
      Ok(mut response) => {
        let mut data = Vec::new();
        response.copy_to(&mut data)?;
        let digest = Sha256::digest(&data);
        let filename = format!("{:X}.just", digest);
        let path = Path::new("fetch").join(&filename);

        if path.exists() {
          eprintln!("old");
        } else {
          fs::write(&path, data)?;
          eprintln!("new");
          new += 1;
        }

        let mut link = Path::new("link")
          .join(&hit.user)
          .join(&hit.repo)
          .join(&hit.hash);
        fs::create_dir_all(&link)?;

        link.push(&filename);

        if fs::read_link(&link).is_err() {
          let dest = Path::new("..").join("..").join("..").join("..").join(path);
          os::unix::fs::symlink(&dest, &link)?;
        }
      }

      Err(err) => eprintln!("failed: {}", err),
    }
  }

  println!(
    "fetched {} new justfiles out of {} total hits",
    new,
    hits.len()
  );

  Ok(())
}
