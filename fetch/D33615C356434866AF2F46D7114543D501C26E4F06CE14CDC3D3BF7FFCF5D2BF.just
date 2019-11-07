
PROJECT_NAME = 'FileDelta'
DISTRO_NAME = 'FileDelta'
SOURCE_NAME = 'main.go'
BINARY_NAME = 'filedelta'

# set ver = version

@_default:
	just _term-lw "{{PROJECT_NAME}}"
	just --list


@build arg='app':
	just _term-lw "{{PROJECT_NAME}}"
	rm -rf ./bin
	# echo "build-{{arg}}"
	just _build-{{arg}}

_build binpath='macos' goos='darwin' goarch='amd64' ext='':
	GOOS={{goos}} GOARCH={{goarch}} go build -o bin/{{binpath}}/{{BINARY_NAME}}{{ext}} {{SOURCE_NAME}}


# Build all OS/Architecture binaries
@build-all:
	just _term-wipe
	just _build-linux
	just _build-linux-32bit
	just _build-linux-arm7
	just _build-macos
	just _build-osx
	just _build-pi
	just _build-win32
	just _build-windows
	just _list-bin


# Build the app for the current OS/Architecture
@build-app:
	just _term-wipe
	just _build-app
	
_build-app:
	#!/usr/bin/env sh
	if [ '{{os()}}' = 'windows' ] && [ '{{arch()}}' != 'x86_64' ]; then
		just build-win32
	else
		just build-{{os()}}
		if [ -d "${HOME}/dev/bin" ]; then
			cp bin/{{os()}}/{{BINARY_NAME}} "${HOME}/dev/bin/"
		fi
	fi


_build-arm binpath='raspberry-pi' goarm='5' goos='linux' ext='':
	GOOS={{goos}} GOARCH=arm GOARM={{goarm}} go build -o bin/{{binpath}}/{{BINARY_NAME}}{{ext}} {{SOURCE_NAME}}


# Build the Linux (32-bit) binary
@build-linux-32bit:
	just _term-we "Building Linux (386) binary..."
	just _build-linux-32bit

@_build-linux-32bit:
	just _build linux-386 linux 386

# Build the Linux (64-bit) binary
@build-linux:
	just _term-we "Building Linux (64-bit) binary..."
	just _build-linux

@_build-linux:
	just _build linux linux amd64

# Build the Linux (ARM7) binary
@build-linux-arm7:
	just _term-we "Building Linux (ARM7) binary..."
	just _build-linux-arm7

@_build-linux-arm7:
	just _build-arm linux-arm7 7

# Build the macOS/OS X Lion+ (64-bit) binary
@build-macos:
	just _term-we "Building macOS (64-bit) binary..."
	just _build-macos

@_build-macos:
	just _build macos darwin amd64


# Build most OS/Architecture binaries
@build-most:
	just _term-wipe
	just _build-most

@_build-most:
	just _term-wipe
	just _build-linux
	just _build-macos
	just _build-win32
	just _build-windows
	just _list-bin


# Build the OS X (32-bit) binary
@build-osx:
	just _term-we "Building OS X (32-bit) binary..."
	just _build-osx

@_build-osx:
	just _build osx darwin 386


# Build the Raspberry Pi binary
@build-pi:
	just _term-we "Building Raspberry Pi binary..."
	just _build-pi

@_build-pi:
	just _build-arm raspberry-pi 5

# Build the Windows (32-bit) binary
@build-win32:
	just _term-we "Building Windows (Win32) binary..."
	just _build-win32

@_build-win32:
	just _build win32 windows 386 '.exe'

# Build the Windows (64-bit) binary
@build-windows:
	just _term-we "Building Windows (amd64) binary..."
	just _build-windows
	
@_build-windows:
	just _build windows windows amd64 '.exe'


# Cleanup build artifacts
@clean:
	just _term-wipe
	echo "Cleaning up..."
	rm -f {{BINARY_NAME}}
	rm -rf bin
	just _list-dir


# Setup distrobutions
distro:
	#!/usr/bin/env sh
	just _term-lw "{{PROJECT_NAME}}"
	# rm -rf ./distro
	for binpath in ./bin/*/{{BINARY_NAME}}*; do
		pathname=`dirname "${binpath}"`
		VERSION=`just version`
		distname="{{BINARY_NAME}}-v${VERSION}-${pathname:6}"
		distpath="./distro/{{BINARY_NAME}}-v${VERSION}/${distname}"
		# echo " \$binpath: ${binpath}"
		# echo "\$pathname: ${pathname}"
		# echo "\$distname: ${distname}"
		# echo "\$distpath: ${distpath}"
		:
		# mkdir -p "./distro/${distname}"
		mkdir -p "${distpath}"
		echo
		cp "${binpath}" "${distpath}/"
		cp "README.md" "${distpath}/"
		cp "LICENSE" "${distpath}/"
		just _list-dir "${distpath}"
		just _dirzip "${distpath}"
		echo

		echo "${pathname}"
	done
	just _list-dir ./distro


_dirzip path:
	#!/usr/bin/env sh
	child={{path}}
	parent=.
	echo "DirZip: {{path}}"
	# echo "  dirzip path: {{path}}"
	# echo " dirzip child: ${child}"
	# echo "dirzip parent: ${parent}"
	cd "${parent}"
	ditto -ck --keepParent --zlibCompressionLevel 9 --norsrc --noqtn --nohfsCompression "${child}" "${child}.zip"


_list-bin:
	#!/usr/bin/env sh
	if [ '{{os()}}' = 'macos' ]; then
		ls -AlhG bin/*
	else
		ls -Alh --color bin/*
	fi

_list-dir path='.':
	#!/usr/bin/env sh
	if [ '{{os()}}' = 'macos' ]; then
		echo '$ ls -AlhG "{{path}}"'
		ls -AlhG "{{path}}"
	else
		echo '$ ls -Alh --color "{{path}}"'
		ls -Alh --color "{{path}}"
	fi


# Run the app
@run +args='':
	just _term-lw "{{PROJECT_NAME}}"
	echo "$ {{BINARY_NAME}} {{args}}"
	go run {{SOURCE_NAME}} {{args}}


# Test Helper
@test id='app' +args='':
	just _term-lw "{{PROJECT_NAME}}"
	just --highlight test-{{id}} {{args}}

# Test the app
@test-app +args='':
	echo '$ echo Touched > test/touched.txt'
	echo Touched > test/touched.txt
	echo '$ go run main.go test/touched.txt'
	go run main.go test/touched.txt
	echo '$ go run main.go store test/touched.txt'
	go run main.go store test/touched.txt
	echo '$ go run main.go check test/touched.txt'
	go run main.go check test/touched.txt
	echo '$ echo TOUCHED > test/touched.txt'
	echo TOUCHED > test/touched.txt
	echo '$ go run main.go check test/touched.txt'
	go run main.go check test/touched.txt; exit 0
	echo '$ echo Touched > test/touched.txt'
	echo Touched > test/touched.txt
	echo '$ go run main.go check test/touched.txt'
	go run main.go check test/touched.txt
	# go test


# Terminal Helper
@term +args='wipe':
	just _term-{{args}}

# Helper recipe to change the terminal label
@_term-label label:
	printf "\033]0;{{label}}\007"

# Helper recipe to change the terminal label, and echo
@_term-le label:
	just _term-label "{{label}}"
	echo "{{label}}"

# Helper recipe to echo, and wipe the buffer
@_term-we label:
	just _term-wipe
	echo "{{label}}"

# Helper recipe to change the terminal label, echo, and wipe the buffer
@_term-lwe label:
	just _term-label "{{label}}"
	just _term-wipe
	echo "{{label}}"

# Helper recipe to change the terminal label and wipe the buffer
@_term-lw label:
	just _term-label "{{label}}"
	just _term-wipe

# Wipe the terminal buffer
@_term-wipe:
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


# Prints the compiler or interpreter version(s)
@version:
	cat {{SOURCE_NAME}} | grep -E 'AppVersion\s+AppMetaData' | cut -d'"' -f2
