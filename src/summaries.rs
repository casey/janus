use crate::common::*;

pub struct Summaries {
  duration: Duration,
  paths: Vec<PathBuf>,
  results: Vec<Result<Summary, String>>,
}

impl Summaries {
  pub fn collect<T: Upgrade<Output = Summary>>(
    paths: &[PathBuf],
    f: fn(&Path) -> Result<Result<T, String>, io::Error>,
  ) -> Result<Summaries, Error> {
    let mut results = Vec::new();

    let start = Instant::now();

    for path in paths {
      results.push(f(path)?);
    }

    let duration = start.elapsed();

    let results = results.upgrade();

    Ok(Summaries {
      paths: paths.iter().cloned().collect(),
      duration,
      results,
    })
  }

  pub fn ok(&self) -> impl Iterator<Item = &Summary> {
    self.results.iter().flat_map(|result| result.as_ref().ok())
  }

  pub fn err(&self) -> impl Iterator<Item = &str> {
    self
      .results
      .iter()
      .flat_map(|result| result.as_ref().err().map(String::as_str))
  }

  pub fn justfiles_with_export(&self) -> usize {
    self
      .ok()
      .filter(|summary| {
        summary
          .assignments
          .values()
          .any(|assignment| assignment.exported)
      })
      .count()
  }

  pub fn justfiles_with_private_recipe(&self) -> usize {
    self
      .ok()
      .filter(|summary| summary.recipes.values().any(|recipe| recipe.private))
      .count()
  }

  pub fn justfiles_with_quiet_recipe(&self) -> usize {
    self
      .ok()
      .filter(|summary| summary.recipes.values().any(|recipe| recipe.quiet))
      .count()
  }

  pub fn justfiles_with_alias(&self) -> usize {
    self
      .ok()
      .filter(|summary| {
        summary
          .recipes
          .values()
          .any(|recipe| !recipe.aliases.is_empty())
      })
      .count()
  }

  pub fn justfiles_with_shebang_recipe(&self) -> usize {
    self
      .ok()
      .filter(|summary| summary.recipes.values().any(|recipe| recipe.shebang))
      .count()
  }

  pub fn justfiles_with_all_quiet_recipes(&self) -> usize {
    self
      .ok()
      .filter(|summary| summary.recipes.values().all(|recipe| recipe.quiet))
      .count()
  }

  pub fn shebang_counts(&self, cutoff: u64) -> Vec<(u64, String)> {
    let mut counter: Counter<String> = Counter::new();

    for summary in self.ok() {
      for recipe in summary.recipes.values() {
        if recipe.shebang {
          if let [Fragment::Text { text }] = recipe.lines[0].fragments.as_slice() {
            counter.insert(text.clone());
          }
        }
      }
    }

    counter.counts(cutoff)
  }

  pub fn recipe_names(&self, cutoff: u64) -> Vec<(u64, String)> {
    let mut counter: Counter<String> = Counter::new();

    for summary in self.ok() {
      for name in summary.recipes.keys().cloned() {
        counter.insert(name);
      }
    }

    counter.counts(cutoff)
  }

  pub fn compare(&self, old: &Summaries) {
    if self.duration > old.duration {
      let increase = self.duration - old.duration;
      println!(
        "new version is slower than old version: +{}s",
        increase.as_millis() as f64 / 1000.0
      );
    }

    if self.duration < old.duration {
      let decrease = old.duration - self.duration;
      println!(
        "new version is faster than old version: -{}s",
        decrease.as_millis() as f64 / 1000.0
      );
    }

    if self.results.len() != old.results.len() {
      panic!(
        "Result length mismatch: {} != {}",
        self.results.len(),
        old.results.len()
      );
    }

    if self.paths != old.paths {
      panic!("Summary path mismatch");
    }

    let mut diffs = old
      .results
      .iter()
      .zip(self.results.iter())
      .map(Diff::from_pair)
      .zip(self.paths.iter().map(PathBuf::as_path))
      .collect::<Vec<(Option<Diff>, &Path)>>();

    diffs.sort();

    for (diff, path) in diffs {
      if let Some(diff) = diff {
        println!("-----------------");
        println!("diff in {}:", path.display());
        println!("{}", diff);
      }
    }
  }
}

impl Display for Summaries {
  fn fmt(&self, f: &mut Formatter) -> fmt::Result {
    writeln!(
      f,
      "total:                            {}",
      self.results.len()
    )?;
    writeln!(f, "ok:                               {}", self.ok().count())?;
    writeln!(
      f,
      "err:                              {}",
      self.err().count()
    )?;
    writeln!(
      f,
      "time:                             {}s",
      self.duration.as_millis() as f64 / 1000.0
    )?;
    writeln!(
      f,
      "justfiles with export:            {}",
      self.justfiles_with_export()
    )?;
    writeln!(
      f,
      "justfiles with private recipe:    {}",
      self.justfiles_with_private_recipe()
    )?;
    writeln!(
      f,
      "justfiles with quiet recipe:      {}",
      self.justfiles_with_quiet_recipe()
    )?;
    writeln!(
      f,
      "justfiles with alias:             {}",
      self.justfiles_with_alias()
    )?;
    writeln!(
      f,
      "justfiles with shebang recipe:    {}",
      self.justfiles_with_shebang_recipe()
    )?;
    writeln!(
      f,
      "justfiles with all quiet recipes: {}",
      self.justfiles_with_all_quiet_recipes()
    )?;

    Ok(())
  }
}
