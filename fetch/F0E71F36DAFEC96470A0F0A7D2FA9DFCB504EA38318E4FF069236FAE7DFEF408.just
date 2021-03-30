s:
	cargo run --bin show_posts

meta:
    cargo run --bin meta-cli
seed:
    cargo run --bin seed

mig:
	diesel migration run
revert:
    diesel migration revert
redo:
    diesel migration redo
gen target:
    diesel migration generate {{target}}

# $ just test select
test target:
    cargo test {{target}} --color=always --no-fail-fast -- --exact -Z unstable-options --format=json --show-output

