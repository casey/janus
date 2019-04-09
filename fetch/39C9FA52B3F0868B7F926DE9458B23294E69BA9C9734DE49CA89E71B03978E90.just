default:
    cargo watch -x "test -- --nocapture"

youtube:
    cargo test youtube -- --nocapture 

douyin:
    cargo test douyin -- --nocapture 