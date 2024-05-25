use super::*;

pub trait Upgrade {
  type Output;

  fn upgrade(self) -> Self::Output;
}

impl<T: Upgrade> Upgrade for Vec<T> {
  type Output = Vec<T::Output>;

  fn upgrade(self) -> Self::Output {
    self.into_iter().map(Upgrade::upgrade).collect()
  }
}

impl<T: Upgrade> Upgrade for BTreeMap<String, T> {
  type Output = BTreeMap<String, T::Output>;

  fn upgrade(self) -> Self::Output {
    self
      .into_iter()
      .map(|(name, value)| (name, value.upgrade()))
      .collect()
  }
}

impl<T: Upgrade> Upgrade for Option<T> {
  type Output = Option<T::Output>;

  fn upgrade(self) -> Self::Output {
    self.map(Upgrade::upgrade)
  }
}

impl<T: Upgrade> Upgrade for Result<T, String> {
  type Output = Result<T::Output, String>;

  fn upgrade(self) -> Self::Output {
    self.map(Upgrade::upgrade)
  }
}
