# Builds and run i3-plasma-integration while watching for file changes.
watch:
	cargo watch -s 'cargo run'

# Runs the deploy scripts locally.
local-deploy:
	TARGET=x86_64-unknown-linux-gnu TRAVIS_TAG=$(git describe --tags --always) ./ci/before_deploy.sh
