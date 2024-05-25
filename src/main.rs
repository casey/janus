use {
  crate::{
    analyze::analyze, config::Config, counter::Counter, diff::Diff, fetch::fetch, hit::Hit,
    search::search, summaries::Summaries, upgrade::Upgrade,
  },
  clap::Parser,
  glob::glob,
  just_dev::summary::{
    Assignment, ConditionalOperator, Dependency, Expression, Fragment, Line, Parameter,
    ParameterKind, Recipe, Summary,
  },
  serde_derive::{Deserialize, Serialize},
  sha2::Digest,
  sha2::Sha256,
  std::{
    collections::{BTreeMap, BTreeSet},
    fmt::{self, Display, Formatter},
    fs::{self, File},
    io, os,
    path::{Path, PathBuf},
    time::{Duration, Instant},
  },
};

type Error = Box<dyn std::error::Error>;

mod analyze;
mod config;
mod counter;
mod diff;
mod fetch;
mod hit;
mod search;
mod summaries;
mod upgrade;

mod dev;
mod release;

fn main() -> Result<(), Error> {
  Config::parse().run()
}
