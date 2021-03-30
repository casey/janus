name := 'spectrusty'

# run all benchmarks
bench:
    cargo +nightly bench --bench boot -- --nocapture
    cargo +nightly bench --bench synth --features=audio -- --nocapture
    cargo +nightly bench --bench video -- --nocapture
    cargo +nightly bench --bench video128 -- --nocapture
    cargo +nightly bench --bench video_plus -- --nocapture

# build all examples
examples:
    cargo build -p audio --bins --release
    just examples/web-ay-player/webpack
    just examples/web-zxspectrum/webpack
    cargo build -p sdl2-zxspectrum --release

# build all docs
doc:
    cargo +nightly doc -p zxspectrum-common --all-features

# run all tests
test:
    cargo test --no-default-features -- --nocapture
    cargo test --no-default-features -- --ignored --nocapture
    cargo test -- --nocapture
    cargo test -- --ignored --nocapture
    cargo test --features=boxed_frame_cache -- --nocapture
    cargo test --features=boxed_frame_cache -- --ignored --nocapture
    cargo build -p zxspectrum-common
    cargo test -p zxspectrum-common -- --nocapture
    cargo build --no-default-features -p zxspectrum-common
    cargo test --no-default-features -p zxspectrum-common -- --nocapture
    cargo build -p audio --bins
    cargo test -p audio -- --nocapture
    cargo test -p sdl2-zxspectrum -- --nocapture

# run clippy tests
clippy:
    touch src/lib.rs
    cargo clippy -- -D warnings
    cargo clippy --no-default-features -- -D warnings
    for directory in spectrusty-*; do \
        cd $directory && \
        touch src/lib.rs && \
        cargo clippy --no-default-features -- -D warnings && \
        cd ..; \
    done
