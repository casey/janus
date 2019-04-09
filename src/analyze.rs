use crate::common::*;

pub(crate) fn analyze(recipe_count_cutoff: u64) -> Result<(), Error> {
  let mut paths = glob("fetch/*.just")?.collect::<Result<Vec<PathBuf>, glob::GlobError>>()?;

  paths.sort();

  println!("Analyzing {} justfiles...", paths.len());

  let release = Summaries::collect(&paths, just_release::summary::summary)?;

  let dev = Summaries::collect(&paths, just_dev::summary::summary)?;

  dev.compare(&release);

  println!("{}", dev);
  println!("----");
  println!("shebangs:");
  for (count, shebang) in dev.shebang_counts(0) {
    println!("    {:3} {}", count, shebang);
  }
  println!();
  println!("recipes:");
  for (count, recipe) in dev.recipe_names(recipe_count_cutoff) {
    println!("    {:3} {}", count, recipe);
  }
  println!();
  println!("justfile names:");
  let hits = Hit::load_search_dir()?;
  let mut counts = BTreeMap::new();
  for hit in hits {
    let filename = hit.path.split('/').last().unwrap().to_owned();
    *counts.entry(filename).or_insert(0) += 1;
  }

  let mut counts = counts
    .into_iter()
    .map(|(filename, count)| (count, filename))
    .collect::<Vec<(u64, String)>>();

  counts.sort();
  counts.reverse();

  for (count, filename) in counts {
    println!("    {:3} {}", count, filename);
  }

  Ok(())
}
