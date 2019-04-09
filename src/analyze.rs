use crate::common::*;

pub(crate) fn analyze(recipe_count_cutoff: u64) -> Result<(), Error> {
  let mut paths = glob("fetch/*.just")?.collect::<Result<Vec<PathBuf>, glob::GlobError>>()?;

  paths.sort();

  println!("Analyzing {} justfiles...", paths.len());

  let v0_4_1 = Summaries::collect(&paths, "v0.4.1", just_0_4_1::summary::summary)?;

  let dev = Summaries::collect(&paths, "dev", just_dev::summary::summary)?;

  dev.compare(&v0_4_1);

  println!();
  println!("{}", dev);
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
