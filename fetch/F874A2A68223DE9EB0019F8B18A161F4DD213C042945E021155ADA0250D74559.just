# Global Constant Environment Variables
# =====================================
export CARGO_TARGET_DIR    := invocation_directory() + "/target"
export RUSTDOCFLAGS        := " -Z unstable-options --disable-per-crate-search "
export RUSTFLAGS        	 := " -Z unstable-options "
export RUST_BACKTRACE      := "full"
export CARGO							 := "cargo -Z unstable-options "

crate 			:= "sak"
profile 		:= "dev"
cargo_flags := " -Z unstable-options "
latest_tag  := `git describe --long --tags --always`
branch 		  := `git rev-parse --abbrev-ref HEAD`
tag     		:= `git describe --long --tags --always --dirty`
output_dir 	:= invocation_directory() + "/dist"

# List available recipes and their arguments.
help:
  just --list

# Print evaluated Justfile variables.
eval:
  just --evaluate

# Display helpful info
@info:
  echo "OS:"
  echo " - Name:     {{os()}}"
  echo " - Arch:     {{arch()}}"
  echo " - Type:     {{os_family()}}"
  echo " - Path:     ${PATH}"
  echo "Git:"
  echo " - Branch:   {{branch}}"
  echo " - Tag:      {{tag}}"

# List names of available recipes.
@list-recipes:
  just --summary

# Edit Justfile in $EDITOR.
edit:
  just --edit

dev: build test doc

# Print raw Justfile to stdout.
dump:
  just --dump

build:
	${CARGO} build  --profile="{{profile}}" --package="{{crate}}" --out-dir="{{output_dir}}"

test:
	${CARGO} test --profile="{{profile}}" --package="{{crate}}"

doc:
	${CARGO} doc --profile="{{profile}}" --package="{{crate}}"

release bump='patch':
	${CARGO} release --no-confirm {{bump}}