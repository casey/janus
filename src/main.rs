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
mod v0_4_1;

use crate::common::*;

fn main() -> Result<(), Error> {
  Config::from_args().run()
}
