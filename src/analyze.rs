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
    println!("    {:2} {}", count, shebang);
  }
  println!();
  println!("recipes:");
  for (count, recipe) in dev.recipe_names(recipe_count_cutoff) {
    println!("    {:2} {}", count, recipe);
  }

  Ok(())
}
