update:
	plataea config/user.dots/plataea.toml

build:
	cd user/scripts && \
		clang -Wall -Wpedantic show_shell.c \
			-o ../bin/show_shell

bats:
	cd user/config/bash && bats -p .
