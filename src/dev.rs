use crate::common::*;

impl Upgrade for Summary {
  type Output = Summary;

  fn upgrade(self) -> Self::Output {
    self
  }
}
