#
# This is a Justfile for https://github.com/casey/just and is much like a Makefile for make
# I highly recommend using just for basic automation.
#

alias ver := version

# Like in make the first recipe is used by default.
# I like listing all the recipes by default.
# I also like wiping the terminal buffer like CLS in DOS. It makes me happy.  :-)
@_default:
	just _term-wipe
	just --list


# The real cleaner
@_clean:
	rm -f *.out
	rm -f output.txt
	rm -rf dist

# Cleanup around here!
clean:
	just _term-wipe
	just _clean
	@just _dir-list


# Directory Lister
_dir-list:
	#!/bin/sh
	if [[ ! -z "$(which lsd)" ]]; then
		echo "$ lsd -al"
		lsd -al
	elif [[ "$(uname -s)" = "Darwin" ]]; then
		echo "$ ls -alG"
		ls -alG
	else
		echo "$ ls -al --color=always"
		ls -al --color=always
	fi
	

# Distribution Helper
@dist sub="release":
	just dist-{{sub}}
# Distribution Releaser
dist-release:
	#!/bin/sh
	just _term-wipe
	just _clean
	goreleaser
	# goreleaser release --skip-publish
	ver="$(git tag | tail -1)"
	ver="${ver:1}"
	if [ -d "distro/templar_${ver}" ]; then
		echo "WARNING: Do you need to tag a new release first?"
		echo "A directory already exists for templar_${ver}"
	else
		mkdir -p "distro/templar_${ver}"
		cd dist
		mv *.{deb,gz,md,rpm,txt,yaml,zip} ../distro/templar_${ver}/
	fi

# Distribution Tester
dist-test:
	just _term-wipe
	@just _clean
	@# goreleaser --snapshot --skip-publish --rm-dist
	goreleaser release --skip-publish


# Run the command line app
run +args="":
	go run cmd/templar/main.go {{args}}

# Run a test
@test cmd="help" +data="example.env":
	just _term-wipe
	just test-{{cmd}} "{{data}}"

# Test with debug enabled
test-debug +data="example.env":
	@# CLI_ENV_VAR="Sound and fury" go run cmd/templar/main.go example.tmpl --data-file example.env CLI_VAR="As you like it" --debug
	CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go example.tmpl --data-file {{data}} --debug

# Test the help system
test-help +data="example.env":
	go run cmd/templar/main.go --help

# Test example.env with .env
test-stdout +data="example.json -f example2.json":
	@# CLI_ENV_VAR="Sound and fury" go run cmd/templar/main.go example.tmpl --data-file example.env CLI_VAR="As you like it"
	CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go example.tmpl --data-file {{data}}

# Test example.env with out .env
test-no-dotenv +data="example.env":
	#!/bin/sh
	if [ -z "{{data}}" ]; then
		echo 'CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go example.tmpl --no-dotenv'
		CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go example.tmpl --no-dotenv
	else
		echo 'CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go example.tmpl --data-file {{data}} --no-dotenv'
		CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go example.tmpl --data-file {{data}} --no-dotenv
	fi

	# CLI_ENV_VAR="Sound and fury" go run cmd/templar/main.go example.tmpl --data-file example.env CLI_VAR="As you like it" --no-dotenv
	

# Test creating an output file
test-with-file +data="example.env":
	#!/bin/sh
	rm -f output.txt
	if [ -z "{{data}}" ]; then
		CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go --output-file output.txt example.tmpl
	else
		CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go --output-file output.txt example.tmpl --data-file {{data}}
	fi
	# CLI_ENV_VAR="Sound and fury" go run cmd/templar/main.go --output-file output.txt example.tmpl --env-file example.env CLI_VAR="As you like it"
	# CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go --output-file output.txt example.tmpl --env-file {{data}}
	# CLI_ENV_VAR="Sound and fury" CLI_VAR="As you like it" go run cmd/templar/main.go --output-file output.txt example.tmpl --data-file {{data}}
	cat output.txt

# Run Go Unit Tests
test-unit +data='':
	just _term-wipe
	@# go test
	@# hr
	go test -coverprofile=c.out
	@hr
	go tool cover -func=c.out

# Wipes the terminal buffer for a clean start
_term-wipe:
	#!/bin/sh
	if [[ ${#VISUAL_STUDIO_CODE} -gt 0 ]]; then
		clear
	elif [[ ${KITTY_WINDOW_ID} -gt 0 ]] || [[ ${#TMUX} -gt 0 ]] || [[ "${TERM_PROGRAM}" = 'vscode' ]]; then
		printf '\033c'
	elif [[ "$(uname)" == 'Darwin' ]] || [[ "${TERM_PROGRAM}" = 'Apple_Terminal' ]] || [[ "${TERM_PROGRAM}" = 'iTerm.app' ]]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [[ -x "$(which tput)" ]]; then
		tput reset
	elif [[ -x "$(which reset)" ]]; then
		reset
	else
		clear
	fi

@version:
	cat templar.go | grep -F 'Version =' | cut -d'"' -f2

