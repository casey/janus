use super::*;

#[derive(Parser)]
pub(crate) enum Config {
  Search,
  Fetch,
  Analyze {
    #[structopt(
      long = "recipe-count-cutoff",
      name = "RECIPE-COUNT-CUTOFF",
      default_value = "20"
    )]
    recipe_count_cutoff: u64,
  },
}

impl Config {
  pub fn run(self) -> Result<(), Error> {
    match self {
      Config::Search => search(),
      Config::Fetch => fetch(),
      Config::Analyze {
        recipe_count_cutoff,
      } => analyze(recipe_count_cutoff),
    }
  }
}
