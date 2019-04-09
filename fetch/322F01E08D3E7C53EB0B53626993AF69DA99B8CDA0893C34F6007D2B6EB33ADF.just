all: test
watch TARGET="all":
	watchexec -cre css,html,rs,toml "just {{TARGET}}"

test:
	cargo test --all --no-default-features
	cargo test --all --features backtrace,futures,log,packer,tokio,tokio-threadpool,warp
