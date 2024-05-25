use super::*;

pub struct Counter<T: Ord + Clone> {
  counts: BTreeMap<T, u64>,
}

impl<T: Ord + Clone> Counter<T> {
  pub fn new() -> Counter<T> {
    Counter {
      counts: BTreeMap::new(),
    }
  }

  pub fn insert(&mut self, value: T) {
    *self.counts.entry(value).or_insert(0) += 1;
  }

  pub fn counts(&self, cutoff: u64) -> Vec<(u64, T)> {
    let mut counts: Vec<(u64, T)> = self
      .counts
      .iter()
      .map(|(value, count)| (*count, value.clone()))
      .collect();

    counts.sort();
    counts.reverse();
    counts.retain(|(count, _)| *count >= cutoff);

    counts
  }
}
