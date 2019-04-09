

PROJECT_NAME = 'Ballistic'
BINARY_NAME = 'ballistic'


@_list-recipes:
	just _term-lw "{{PROJECT_NAME}}"
	just --list


# Build the app for the current OS/Architecture
@build-app:
	just term-wipe
	just _build-app
	
_build-app:
	#!/usr/bin/env sh
	if [ '{{os()}}' = 'windows' ] && [ '{{arch()}}' != 'x86_64' ]; then
		just build-win32
	else
		just build-{{os()}}
		if [ -d "${HOME}/dev/bin" ]; then
			cp bin/{{os()}}/ballistic "${HOME}/dev/bin/"
		fi
	fi

@build arg='app':
	term-wipe
	rm -rf ./bin
	# echo "build-{{arg}}"
	just _build-{{arg}}


_build binpath='macos' goos='darwin' goarch='amd64' ext='':
	GOOS={{goos}} GOARCH={{goarch}} go build -o bin/{{binpath}}/ballistic{{ext}} ballistic.go

_build-arm binpath='raspberry-pi' goarm='5' goos='linux' ext='':
	GOOS={{goos}} GOARCH=arm GOARM={{goarm}} go build -o bin/{{binpath}}/ballistic{{ext}} ballistic.go


# Build all OS/Architecture binarys
@build-all:
	term-wipe
	just _build-linux
	just _build-linux-32bit
	just _build-linux-arm7
	just _build-macos
	just _build-osx
	just _build-pi
	just _build-win32
	just _build-windows
	just _list-dir 'bin/*'


# Build the Linux (32-bit) binary
build-linux-32bit:
	term-wipe
	@echo "Building Linux (386) binary..."
	@# GOOS=linux GOARCH=386 go build -o bin/linux-386/ballistic ballistic.go
	@just _build linux-386 linux 386

# Build the Linux (64-bit) binary
@build-linux:
	term-wipe
	echo "Building Linux (64-bit) binary..."
	# GOOS=linux GOARCH=amd64 go build -o bin/linux-amd64/ballistic ballistic.go
	just _build-linux

@_build-linux:
	just _build linux linux amd64

# Build the Linux (ARM7) binary
build-linux-arm7:
	@echo "Building Linux (ARM7) binary..."
	@# GOOS=linux GOARCH=arm GOARM=7 go build -o bin/linux-arm7/ballistic ballistic.go
	@just _build-arm linux-arm7 7


# Build the macOS (64-bit) binary
@build-macos:
	term-wipe
	echo "Building macOS (64-bit) binary..."
	just _build-macos

@_build-macos:
	just _build macos darwin amd64


# Build most OS/Architecture binarys
@build-most:
	term-wipe
	just _build-most

@_build-most:
	just term-wipe
	just _build-linux
	just _build-macos
	just _build-win32
	just _build-windows
	just _list-bin


# Build the OS X (32-bit) binary
build-osx:
	@echo "Building OS X (32-bit) binary..."
	@# GOOS=darwin GOARCH=386 go build -o bin/osx/ballistic ballistic.go
	@just _build osx darwin 386

# Build the Raspberry Pi binary
build-pi:
	@echo "Building Raspberry Pi binary..."
	@# GOOS=linux GOARCH=arm GOARM=5 go build -o bin/raspberry-pi/ballistic ballistic.go
	@just _build-arm raspberry-pi 5

# Build the Windows (32-bit) binary
@build-win32:
	echo "Building Windows (Win32) binary..."
	# GOOS=windows GOARCH=386 go build -o bin/win32/ballistic.exe ballistic.go
	just _build-win32

@_build-win32:
	just _build win32 windows 386 '.exe'

# Build the Windows (64-bit) binary
@build-windows:
	echo "Building Windows (amd64) binary..."
	# GOOS=windows GOARCH=amd64 go build -o bin/windows/ballistic.exe ballistic.go
	just _build-windows
	
@_build-windows:
	just _build windows windows amd64 '.exe'


# Clean, Build, Distro
@cbd +args='':
	term-wipe
	# just clean
	just _build-app
	echo
	just distro


# Clean, Build, Run
@cbr +args='':
	term-wipe
	# just clean
	just _build-app
	echo
	just _run {{args}}


# Cleanup build artifacts
@clean:
	term-wipe
	echo "Cleaning up..."
	rm -f ballistic
	rm -rf bin
	just _list-dir

# Setup distrobutions
distro:
	#!/usr/bin/env sh
	just term-wipe
	rm -rf ./distro
	for binpath in ./bin/*/ballistic*; do
		pathname=`dirname "$binpath"`
		distname="ballistic-v${VERSION}-${pathname:6}"
		distpath="./distro/${distname}"
		# echo " \$binpath: $binpath"
		# echo "\$pathname: $pathname"
		# echo "\$distname: $distname"
		# echo "\$distpath: $distpath"
		mkdir -p "./distro/$distname"
		echo
		cp "$binpath" "${distpath}/"
		cp "README.md" "${distpath}/"
		cp "LICENSE" "${distpath}/"
		just _list-dir ${distpath}
		just _dirzip "$distpath"
		echo

		# echo "${pathname}"
	done
	just _list-dir ./distro


_dirzip path:
	#!/usr/bin/env sh
	child=`basename "{{path}}"`
	parent=`dirname "{{path}}"`
	echo "DirZip: {{path}}"
	# echo "  dirzip path: {{path}}"
	# echo " dirzip child: ${child}"
	# echo "dirzip parent: ${parent}"
	cd "${parent}"
	ditto -ck --keepParent --zlibCompressionLevel 9 --norsrc --noqtn --nohfsCompression "${child}" "${child}.zip"


# Justfile Environment Variables
@env:
	term-wipe
	echo "  Justfile Environment Variables:"
	env | sort


# Pull Go packages
go-get +args='':
	go get {{args}}


# Just info
@info:
	term-wipe
	echo "os_family(): {{os_family()}}"
	echo "       os(): {{os()}}"
	echo "     arch(): {{arch()}}"


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
	just term-wipe
	just _run {{args}}

@_run +args='':
	# BALLISTIC_WEIGHT=grams bin/{{os()}}/ballistic
	# bin/{{os()}}/ballistic
	echo "$ ballistic {{args}}"
	go run ballistic.go {{args}}


# Run time tests with timeit
speed:
	@just term-wipe
	timeit ./ballistic RuneImp "./ballistic RuneImp 'Command Line'"


# Terminal Helper
term +args='wipe':
	#!/usr/bin/env sh
	if [ '{{args}}' = 'wipe' ]; then
		just term-{{args}}
	else
		just _term-{{args}}
	fi

# Helper recipe to clear the screen and put a break between the last output and this
_term-clear message='--CLEAR--' string='=':
	#!/usr/bin/env sh
	msg='{{message}}'
	columns=$(tput cols)
	msg_mid=$((${#msg} / 2))
	col_mid=$(($columns / 2))
	row_mid=$(($col_mid - $msg_mid))
	line_break=""
	while [ ${#line_break} -lt $columns ]; do
		line_break="${line_break}{{string}}"
	done
	echo "$line_break"
	printf "\n\n\n\n\n%*s\n\n\n\n\n\n" $row_mid '{{message}}' 2>/dev/null
	echo "$line_break"
	clear

# Helper recipe to change the terminal label
_term-label label:
	@printf "\033]0;{{label}}\007"

# Helper recipe to change the terminal label, and echo
_term-le label:
	@just _term-label "{{label}}"
	@echo "{{label}}"

# Helper recipe to echo, and wipe the buffer
_term-we label:
	@just term-wipe
	@echo "{{label}}"

# Helper recipe to change the terminal label, echo, and wipe the buffer
_term-lwe label:
	@just _term-label "{{label}}"
	@just term-wipe
	@echo "{{label}}"

# Helper recipe to change the terminal label and wipe the buffer
_term-lw label:
	@just _term-label "{{label}}"
	@just term-wipe

# Helper recipe to wipe the terminal buffer
term-wipe:
	#!/usr/bin/env sh
	if [ '{{os()}}' = 'macos' ]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [ -f `which tput` ]; then
		tput reset
	elif [ -f `which reset` ]; then
		reset
	else
		just _term-clear
	fi


# Test all examples
test:
	@just term-wipe
	@echo
	./ballistic 'Command Line'
	@echo


# Prints the compiler or interpreter version(s)
ver:
	@just term-wipe
	@go version

