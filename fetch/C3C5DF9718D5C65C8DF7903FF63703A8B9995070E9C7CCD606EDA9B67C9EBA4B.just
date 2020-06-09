build:
    #!/bin/bash
    RUSTFLAGS='-C target-cpu=native -C link-arg=-s' cargo build --release --features=ui

coverage:
    #!/bin/bash
    cargo tarpaulin -v  

size:
    #!/bin/bash
    /bin/du -h target/release/nmotd

time:
    #!/usr/bin/bash
    hyperfine target/release/nmotd
