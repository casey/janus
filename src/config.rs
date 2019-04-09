use crate::common::*;

#[derive(StructOpt)]
pub(crate) enum Config {
  #[structopt(name = "search")]
  Search {
    #[structopt(long = "user-session", name = "USER-SESSION")]
    user_session: String,
  },
  #[structopt(name = "fetch")]
  Fetch,
  #[structopt(name = "analyze")]
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
      Config::Search { user_session } => search(user_session),
      Config::Fetch => fetch(),
      Config::Analyze {
        recipe_count_cutoff,
      } => analyze(recipe_count_cutoff),
    }
  }
}
