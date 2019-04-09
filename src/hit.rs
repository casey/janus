use crate::common::*;

#[derive(Debug, Serialize, Deserialize, Ord, PartialOrd, Eq, PartialEq)]
pub(crate) struct Hit {
  pub user: String,
  pub repo: String,
  pub hash: String,
  pub path: String,
}
