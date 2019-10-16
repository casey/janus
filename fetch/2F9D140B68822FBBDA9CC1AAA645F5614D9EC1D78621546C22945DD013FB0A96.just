build:
    cargo build --release

test: build
    cargo test
    python3 specs.py

clean:
    rm -f a.out
    rm -rf specbin/
    cargo clean

docs:
    cd docs/; docket

clippy:
    cargo clippy

bench opt_level="3": build
    #!/usr/bin/env python3
    import os
    import glob
    import subprocess
    
    for bench in glob.glob("spec/bench/*.ulg"):
        output = bench.lstrip('spec/').rstrip('.ulg')
        output = os.path.join("specbin", "bench", output)
        try:
            os.makedirs(os.path.dirname(output))
        except OSError:
            pass
        print("bench={0}, output={1}, opt={2}".format(bench, output, {{opt_level}}))
        subprocess.call("target/release/ullage {0} -O{1} -o {2}"
                .format(bench, {{opt_level}}, output))
        subprocess.call("time {0}".format(output))