port = "9000"

# pool_max=1; to run with different port: `just port=9000 run`
run_1:
    cargo build && RUST_LOG=info target/debug/clickhouse-hang 'tcp://localhost:{{port}}?pool_max=1&pool_min=1'

# pool_max=2; to run with different port: `just port=9000 run`
run_2:
    cargo build && RUST_LOG=info target/debug/clickhouse-hang 'tcp://localhost:{{port}}?pool_max=2&pool_min=1'
