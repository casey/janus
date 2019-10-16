##
# Taskrunner
#
# This requires "just". See https://github.com/casey/just for more
# details.
#
# USAGE:
#   just --list
#   just <task>
##

base_dir  := `realpath $PWD`
src_dir   := base_dir + "/src"
dist_dir  := base_dir + "/dist"
demo_dir  := dist_dir + "/demo"
test_dir  := base_dir + "/test"



##     ##
# BUILD #
##     ##

# Build site!
@build: _check_dependencies
	just _header "Building JS Mate Poe!"

	just _pull_js_chain
	just _watch_css
	just _watch_js

	just test

	# Done!
	just _success "JS Mate Poe has been built: {{ dist_dir }}"


# Run unit tests.
@test: _check_dependencies
	just _header "Unit tests!"
	npx karma start --single-run --browsers ChromeHeadless "{{ base_dir }}/karma.conf.js"
	just _notify "Unit tests are looking good!"


# Watch for changes to JS files.
@watch: _check_dependencies
	just _header "Watching for Changes"

	watchexec --postpone --no-shell --watch "{{ src_dir }}/scss" --debounce 1000 --exts scss -- just _watch_css & \
	watchexec --postpone --no-shell --watch "{{ src_dir }}/js" --debounce 1000 --exts mjs -- just _watch_js & \
	watchexec --postpone --no-shell --watch "{{ test_dir }}" --debounce 1000 --exts js -- just _watch_js


# CSS build task(s).
@_watch_css:
	just _sassc "{{ src_dir }}/scss/js-mate-poe.scss" "{{ src_dir }}/css/js-mate-poe.css"
	just _sassc "{{ src_dir }}/scss/demo.scss" "{{ demo_dir }}/assets/demo.css"

	just _css_to_js

	just _brotli "{{ dist_dir }}" "css"
	just _gzip "{{ dist_dir }}" "css"


# JS build task(s).
@_watch_js:
	just _eslint

	just _google-closure-compiler "{{ src_dir }}/js/js-mate-poe.mjs" "{{ dist_dir }}/js-mate-poe.min.js"
	just _google-closure-compiler "{{ src_dir }}/js/demo.mjs" "{{ demo_dir }}/assets/demo.min.js"

	just _brotli "{{ dist_dir }}" "js"
	just _gzip "{{ dist_dir }}" "js"

	just _notify "JS is looking good!"



##   ##
# CSS #
##   ##

# SASSC.
@_sassc IN OUT:
	just _header "Compiling $( basename "{{ IN }}" )."
	sassc --style=compressed "{{ IN }}" "{{ OUT }}"
	just _csso "{{ OUT }}" "{{ OUT }}"


# CSSO.
@_csso IN OUT:
	just _header "Minifying CSS."
	csso -i "{{ IN }}" -o "{{ OUT }}"


# Build a JS module from the CSS.
@_css_to_js:
	just _header "Rebuilding CSS module."

	# Make sure we have compressed files to use.
	[ -f "{{ src_dir }}/css/js-mate-poe.css" ] || just _die "Missing js-mate-poe.css."

	# Start it.
	cp -a "{{ src_dir }}/skel/_css.mjs" "{{ src_dir }}/skel/css.tmp"

	# The main CSS.
	echo "export const CSS = '$( cat "{{ src_dir }}/css/js-mate-poe.css" )';" >> "{{ src_dir }}/skel/css.tmp"

	# Move the file to its normal place!
	mv "{{ src_dir }}/skel/css.tmp" "{{ src_dir }}/js/_css.mjs"


##          ##
# JAVASCRIPT #
##          ##

# Eslint.
@_eslint:
	just _header "Linting Javascript."
	npx eslint \
		--color \
		"{{ src_dir }}/js"/*.mjs \
		"{{ src_dir }}/js/vue"/*.mjs \
		"{{ test_dir }}"/*.js


# Eslint Fix.
@_eslint-fix:
	just _header "Fixing Javascript."
	npx eslint \
		--color \
		--fix \
		"{{ src_dir }}/js"/*.mjs \
		"{{ src_dir }}/js/vue"/*.mjs \
		"{{ test_dir }}"/*.js || true


# Closure Compiler.
@_google-closure-compiler IN OUT:
	just _header "Compiling $( basename "{{ IN }}" )."

	npx google-closure-compiler \
		--env BROWSER \
		--language_in STABLE \
		--language_out STABLE \
		--externs "{{ src_dir }}/js/_externs.js" \
		--js "{{ src_dir }}/js"/*.mjs \
		--js "{{ src_dir }}/js/vue"/*.mjs \
		--js_output_file "{{ OUT }}" \
		--jscomp_off globalThis \
		--jscomp_off unknownDefines \
		--assume_function_wrapper \
		--compilation_level ADVANCED \
		--entry_point "{{ IN }}" \
		--browser_featureset_year 2019 \
		--isolation_mode IIFE \
		--module_resolution BROWSER \
		--strict_mode_input \
		--use_types_for_optimization \
		--warning_level VERBOSE

	# Generate a truly final version.
	cat "{{ src_dir }}/skel/js-mate-poe.min.js" "{{ OUT }}" > "{{ src_dir }}/js/tmp.js"
	mv "{{ src_dir }}/js/tmp.js" "{{ OUT }}"


# Pull JS Chain.
@_pull_js_chain:
	just _header "Pulling third-party dependencies."

	# Vue JS.
	[ ! -f "{{ demo_dir }}/assets/vue.min.js" ] || rm "{{ demo_dir }}/assets/vue.min.js"
	wget -q -O "{{ demo_dir }}/assets/vue.min.js" "https://raw.githubusercontent.com/vuejs/vue/dev/dist/vue.min.js"



##     ##
# OTHER #
##     ##

# Compress files with Brotli.
@_brotli DIR EXT:
	just _info "Generating static Brotli files."

	[ -d "{{ DIR }}" ] || just _die "Invalid directory: {{ DIR }}"
	[ ! -z "{{ EXT }}" ] || just _die "An extension is required."

	# Remove existing Brotli files.
	find "{{ DIR }}" -iname "*.{{ EXT }}.br" -type f -delete

	# Encode!
	find "{{ DIR }}" -iname "*.{{ EXT }}" -type f -print0 | xargs -0 brotli -q 11


# Compress files with Gzip.
@_gzip DIR EXT:
	just _info "Generating static Gzip files."

	[ -d "{{ DIR }}" ] || just _die "Invalid directory: {{ DIR }}"
	[ ! -z "{{ EXT }}" ] || just _die "An extension is required."

	# Remove existing Gzip files.
	find "{{ DIR }}" -iname "*.{{ EXT }}.gz" -type f -delete

	# Encode!
	find "{{ DIR }}" -iname "*.{{ EXT }}" -type f -print0 | xargs -0 gzip -k -9



##           ##
# DEPENENCIES #
##           ##

# Install system requirements.
@_check_dependencies:
	just _header "Starting Up"
	just _info "Checking runtime dependencies."

	# Make sure we have NPM.
	[ $( command -v npm ) ] || just _die "NPM is required."

	# Make sure we have wget.
	[ $( command -v wget ) ] || just _die "Wget is required."

	# Brotli.
	[ $( command -v brotli ) ] || just _install-os "brotli"

	# Gzip.
	[ $( command -v gzip ) ] || just _install-os "gzip"

	# SassC.
	[ $( command -v sassc ) ] || just _install-os "sassc"

	# Watchexec.
	[ $( command -v watchexec ) ] || just _install-cargo "watchexec"

	# The lightest possible Node check.
	[ -d "{{ base_dir }}/node_modules" ] || npm i


# Install Apt application.
@_install-apt THING:
	just _header "Installing {{ THING }} via Apt"

	[ $( command -v "apt-get" ) ] || just _die "apt-get is required to install {{ THING }}."

	sudo apt-get update && sudo apt-get install {{ THING }} -y
	[ $( command -v "{{ THING }}" ) ] || exit 1

	just _success "{{ THING }} has been installed."


# Install Homebrew application.
@_install-brew THING:
	just _header "Installing {{ THING }} via Homebrew"

	[ $( command -v brew ) ] || just _die "Homebrew is required to install {{ THING }}."

	brew install {{ THING }}
	[ $( command -v "{{ THING }}" ) ] || exit 1

	just _success "{{ THING }} has been installed."


# Install Cargo application.
@_install-cargo THING:
	just _header "Installing {{ THING }} via Cargo"

	# Cargo
	[ $( command -v cargo ) ] || just _die "Cargo is required to install {{ THING }}."

	cargo install {{ THING }} --force
	[ $( command -v "{{ THING }}" ) ] || exit 1

	just _success "{{ THING }} has been installed."


# OS Install.
_install-os THING:
	#!/usr/bin/env bash
	if [ "linux" = "{{ os() }}" ]; then
		just _install-apt "{{ THING }}"
	elif [ "macos" = "{{ os() }}" ]; then
		just _install-brew "{{ THING }}"
	else
		just _error "Unsupported operating system."
		exit 1
	fi

	[ $( command -v {{ THING }} ) ] || exit 1



##             ##
# NOTIFICATIONS #
##             ##

# Task header.
@_header TASK:
	echo "\e[34;1m[Task] \e[0;1m{{ TASK }}\e[0m"

# Echo an informational comment.
@_info COMMENT:
	echo "\e[95;1m[Info] \e[0;1m{{ COMMENT }}\e[0m"

# Echo an error.
@_error COMMENT:
	>&2 echo "\e[31;1m[Error] \e[0;1m{{ COMMENT }}\e[0m"

# Error and exit.
@_die COMMENT:
	just _error "{{ COMMENT }}"
	exit 1

# Echo a success.
@_success COMMENT:
	echo "\e[92;1m[Success] \e[0;1m{{ COMMENT }}\e[0m"

# Fancy bubble notification for Linux.
@_notify COMMENT:
	[ ! $( command -v "notify-send" ) ] || notify-send -i "{{ src_dir }}/img/icon.png" --category dev.validate -h int:transient:1 -t 3000 "JS Mate Poe" "{{ COMMENT }}"
