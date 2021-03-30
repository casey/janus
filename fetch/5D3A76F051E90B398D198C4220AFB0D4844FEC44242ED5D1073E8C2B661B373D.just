export GO111MODULE := "on"
export BINARY := "mcsm"
export VERSION := `test -z ${CI:-""} && echo "${USER:-'userless'}-dev" || git describe --always --abbrev=0 --dirty --tags`
export COMMIT := `git describe --always --abbrev=0 || echo "commit-less"`

alias c := check
alias cl := clean
alias b := build
alias t := test
alias co := coverage
alias i := integration
alias te := test-env
alias p := package
alias gp := gen-preset

# Runs pre build checks to verify formatting, linting, and such
check:
  ./scripts/check.sh

# Cleans up build artifacts
clean:
  ./scripts/clean.sh

# Compile binary for current toolchain
build local="no":
  ./scripts/build.sh "{{local}}"

# Run all unit tests
test:
  ./scripts/test.sh

# Generates a test coverage report
coverage open_browser="yes":
  ./scripts/coverage.sh {{open_browser}}

_build_integration_image: build
  ./scripts/build_integration_image.sh

# Runs a given integration suite list
integration suite="all": _build_integration_image
  ./scripts/integration.sh "{{suite}}"

# Enters a bash session inside integration test image
test-env: _build_integration_image
  ./scripts/test_env.sh

# Packages built binaries into release-ready tars
package: build
  ./scripts/package.sh

# Generate config preset type or value definitions for a yaml config file
gen-preset file target="type":
	./scripts/generate_yaml_preset.sh "{{file}}" "{{target}}"
