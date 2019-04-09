mod analyze;
mod common;
mod config;
mod counter;
mod diff;
mod error;
mod fetch;
mod hit;
mod search;
mod summaries;
mod upgrade;

mod dev;
mod release;

use crate::common::*;

fn main() -> Result<(), Error> {
  Config::from_args().run()
}
