#!/usr/bin/env just --justfile

# the current branch in git
currentBranch := `git rev-parse --abbrev-ref HEAD`

# the number of unstaged changes in git
currentStatus := `git status -s | wc -l | awk '$1=$1'`

# version number from cargo.toml file
version := `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p' Cargo.toml`

# Aliases -------------------------------------------------------------------------------------------
alias b := build
alias c := check
alias d := doc
alias f := fmt
alias t := test
alias bk := book
alias cp := clippy
# ---------------------------------------------------------------------------------------------------

# lists the tasks (ensure this is task #1 in the list)
@_list:
  just --list

# Depending on the platform you are running on find the right start function to run
@_browse url:
    #!/usr/bin/env bash
    case $( uname -s ) in
        Darwin)   open='open';;
        MINGW*)   open='start';;
        MSYS*)    open='start';;
        CYGWIN*)  open='cygstart';;
        *)
            if uname -r | grep -q Microsoft; then
                open='powershell.exe'
                openopt='Start'
            else
                open='xdg-open'
            fi;;
    esac

    # open it in a browser
    ${BROWSER:-$open} $openopt "{{url}}"

# Hidden implementation so that book does not output function to the user and spam the terminal
@_book topic:
    #!/usr/bin/env bash
    list=('cargo' 'crate' 'doc' 'edition' 'error' 'example' 'rustc' 'std')
    case {{topic}} in
        cargo)   url='https://doc.rust-lang.org/cargo/' ;;
        crate)   url='https://crates.io' ;;
        doc)     url='https://doc.rust-lang.org/rustdoc/' ;;
        edition) url='https://doc.rust-lang.org/stable/edition-guide/' ;;
        error)   url='https://doc.rust-lang.org/error-index.html' ;;
        example) url='https://doc.rust-lang.org/stable/rust-by-example/' ;;
        rustc)   url='https://doc.rust-lang.org/rustc/' ;;
        std)     url='https://doc.rust-lang.org/std/' ;;
        *) 
            echo "Unknown topic: '{{topic}}'" ; 
            echo "Valid options are:" ; 
            printf '  %s\n' "${list[@]}"
            return 1 ;;
    esac
    just _browse $url &>/dev/null

# Build projcet in debug mode
build:
    cargo build

# Compile and run tests for project
test: build
    cargo test

# Check project and dependencies for errors
check:
    cargo check

# Run tests with backtrace on
backtrace: build
    RUST_BACKTRACE=1 cargo test

# Run the nightly version of fmt
fmt:
    cargo +nightly fmt

# Run the nightly version of clippy
clippy:
    cargo +nightly clippy

# Install all rust components needed for development
install-deps:
    rustup toolchain add nightly
    rustup update
    rustup component add rustfmt --toolchain nightly
    rustup component add clippy --toolchain nightly

# Generate documentation for project and open in browser
doc:
    cargo doc --open

# Open a rust reference book for the topic provided
@book topic:
    just _book {{topic}} 2>/dev/null
