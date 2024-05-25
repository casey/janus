use super::*;

#[derive(PartialOrd, Ord, PartialEq, Eq)]
pub enum Diff<'a> {
  Summary { old: &'a Summary, new: &'a Summary },
  Error { old: &'a str, new: &'a str },
  SummaryToError { old: &'a Summary, new: &'a str },
  ErrorToSummary { old: &'a str, new: &'a Summary },
}

impl<'a> Diff<'a> {
  pub fn from_pair(
    pair: (&'a Result<Summary, String>, &'a Result<Summary, String>),
  ) -> Option<Diff<'a>> {
    match pair {
      (Ok(old), Ok(new)) => {
        if new != old {
          Some(Diff::Summary { old, new })
        } else {
          None
        }
      }
      (Err(old), Err(new)) => {
        if new != old {
          Some(Diff::Error { old, new })
        } else {
          None
        }
      }
      (Err(old), Ok(new)) => Some(Diff::ErrorToSummary { old, new }),
      (Ok(old), Err(new)) => Some(Diff::SummaryToError { old, new }),
    }
  }
}

impl<'a> Display for Diff<'a> {
  fn fmt(&self, f: &mut Formatter) -> fmt::Result {
    match self {
      Diff::Summary { old, new } => {
        writeln!(f, "summary mismatch:")?;
        let old = format!("{:?}", old);
        let new = format!("{:?}", new);
        write!(
          f,
          "{}",
          colored_diff::PrettyDifference {
            expected: &old,
            actual: &new
          }
        )?;
      }
      Diff::Error { old, new } => {
        writeln!(f, "error mismatch:")?;
        write!(
          f,
          "{}",
          colored_diff::PrettyDifference {
            expected: old,
            actual: new
          }
        )?;
      }
      Diff::SummaryToError { old, new } => {
        writeln!(f, "old summary is now error:")?;
        writeln!(f, "old summary:")?;
        writeln!(f, "{:?}", old)?;
        writeln!(f, "new error:")?;
        write!(f, "{}", new)?;
      }
      Diff::ErrorToSummary { old, new } => {
        writeln!(f, "old error is now summary:")?;
        writeln!(f, "old error:")?;
        writeln!(f, "{}", old)?;
        writeln!(f, "new summary:")?;
        write!(f, "{:?}", new)?;
      }
    }

    Ok(())
  }
}
