build:
    sudo systemctl start postgresql.service
    cd js && npm run build
    cd ..
    cargo build
develop:
    just build
    cd js && npm run watch &
    cd ..
    cargo run