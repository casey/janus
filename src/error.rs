use crate::common::*;

#[derive(Debug)]
pub enum Error {
  Reqwest(reqwest::Error),
  InvalidHeaderValue(http::header::InvalidHeaderValue),
  Io(io::Error),
  Serde(serde_yaml::Error),
  Pattern(glob::PatternError),
  Glob(glob::GlobError),
  Status(http::StatusCode),
  Empty,
}

impl From<reqwest::Error> for Error {
  fn from(error: reqwest::Error) -> Error {
    Error::Reqwest(error)
  }
}

impl From<http::header::InvalidHeaderValue> for Error {
  fn from(error: http::header::InvalidHeaderValue) -> Error {
    Error::InvalidHeaderValue(error)
  }
}

impl From<io::Error> for Error {
  fn from(error: io::Error) -> Error {
    Error::Io(error)
  }
}

impl From<serde_yaml::Error> for Error {
  fn from(error: serde_yaml::Error) -> Error {
    Error::Serde(error)
  }
}

impl From<glob::PatternError> for Error {
  fn from(error: glob::PatternError) -> Error {
    Error::Pattern(error)
  }
}

impl From<glob::GlobError> for Error {
  fn from(error: glob::GlobError) -> Error {
    Error::Glob(error)
  }
}

impl From<http::StatusCode> for Error {
  fn from(error: http::StatusCode) -> Error {
    Error::Status(error)
  }
}
