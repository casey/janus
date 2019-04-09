default:
    cargo watch --clear --exec build

b:
    cargo build --release
  
r-short: 
    cargo run < ./data/mempool_short.csv
  
r: 
    cargo run < ./data/mempool.csv
