#
# CSVhead Justfile
#
APP_NAME = 'CSVhead'
CLI_NAME = 'csvhead'
MAIN_CODE = 'main.go'
ZIP_NAME="CSVhead"


@_default:
	just _term-wipe
	just --list


# Build App
build +args='':
	#!/bin/sh
	just _term-wipe
	if [ '{{os()}}' = 'windows' ]; then
		bin_file={{CLI_NAME}}.exe
	else
		bin_file={{CLI_NAME}}
	fi
	go build -o "${bin_file}" main.go {{args}}
	mv "${bin_file}" "${GOBIN}/"
	ls -hl "${GOBIN}/{{CLI_NAME}}"*


# Create a Zip file based on a directory
dirzip path:
	ditto -ck --keepParent --zlibCompressionLevel 9 --norsrc --noqtn --nohfsCompression "{{path}}" "{{path}}.zip"


# Build App Distribution
dist:
	#!/bin/bash
	just _term-wipe
	version="$(just version)"
	distro_path="${PWD}/dist/{{ZIP_NAME}}-v${version}"
	linux_distro="${distro_path}/{{ZIP_NAME}}-v${version}-linux"
	macos_distro="${distro_path}/{{ZIP_NAME}}-v${version}-macos"
	windows_distro="${distro_path}/{{ZIP_NAME}}-v${version}-windows"

	[[ -d "${distro_path}"  ]] && rm -rf "${distro_path}/*"

	mkdir -p "${linux_distro}"
	mkdir -p "${macos_distro}"
	mkdir -p "${windows_distro}"

	GOOS=linux GOARCH=amd64 go build -o "${linux_distro}/{{CLI_NAME}}" main.go
	GOOS=darwin GOARCH=amd64 go build -o "${macos_distro}/{{CLI_NAME}}" main.go
	GOOS=windows GOARCH=amd64 go build -o "${windows_distro}/{{CLI_NAME}}.exe" main.go

	cp README.md "${linux_distro}/"
	cp README.md "${macos_distro}/"
	cp README.md "${windows_distro}/"

	just dirzip "${linux_distro}"
	just dirzip "${macos_distro}"
	just dirzip "${windows_distro}"

	ls -Ahl "${distro_path}/"*


# Run Code
run +args='':
	just _term-wipe
	go run main.go {{args}}


test +args='':
	just _term-wipe
	cat example.csv | go run main.go {{args}}


# Set Terminal Title
_term-title title='':
	@printf "\033]0;%s\007" "{{title}}"

# Wipe Terminal Buffer and Scrollback Buffer
_term-wipe:
	#!/bin/sh
	if [ ${#VISUAL_STUDIO_CODE} -gt 0 ]; then
		clear
	elif [ ${KITTY_WINDOW_ID} -gt 0 ]; then
		printf '\033c'
	elif [ "$(uname)" == 'Darwin' ] && [ ${#TMUX} -eq 0 ]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [ -f "$(which tput)" ]; then
		tput reset
		if [ ${#TMUX} -gt 0 ]; then
			tput cup 0 0
		fi
	elif [ -f "$(which reset)" ]; then
		reset
	else
		clear
		# alias cls="clear; printf '\33[3J'"
		# echo -ne '\033]50;ClearScrollback\a' # For iTerm2
	fi
	just _term-title "{{APP_NAME}}"


# Display version of app
version:
	#!/bin/sh
	cat "{{MAIN_CODE}}" | grep 'APP_VERSION' | head -1 | cut -d'"' -f2

