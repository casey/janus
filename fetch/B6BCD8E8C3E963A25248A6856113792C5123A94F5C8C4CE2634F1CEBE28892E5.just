test:
  cargo test --features=rand/std
  cargo test --features=rand/std,use-simd

bench:
  cargo bench --bench export --features=rand/std -- --nocapture
  cargo bench --bench render --features=rand/std -- --nocapture
  cargo bench --bench render --features=rand/std,use-simd -- --nocapture
  cargo bench --bench render --features=rand/std,use-sleef -- --nocapture
