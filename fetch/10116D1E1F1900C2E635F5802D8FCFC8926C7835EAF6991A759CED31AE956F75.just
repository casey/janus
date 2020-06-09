

@_default:
	just _term-wipe
	just --list

# Build and install CaseIt
build:
	@just _term-wipe
	go build -o caseit cmd/caseit/main.go
	mv caseit "${GOBIN}/"

# Build distro
distro:
	goreleaser


# Run CaseIt
run cmd="word" arg="-s" +args='" ALL CAPS to go thru 1--6 of the 1/2 with the correct CIA ID over GRPC"':
	@just _term-wipe
	go run cmd/caseit/main.go {{cmd}} {{arg}} {{args}}


_term-wipe:
	#!/bin/sh
	if [[ ${#VISUAL_STUDIO_CODE} -gt 0 ]]; then
		clear
	elif [[ ${KITTY_WINDOW_ID} -gt 0 ]] || [[ ${#TMUX} -gt 0 ]] || [[ "${TERM_PROGRAM}" = 'vscode' ]]; then
		printf '\033c'
		# if [[ -x "$(which tput)" ]]; then
		# 	printf '\033[22;0t' # Put title in stack
		# 	tput reset
		# 	# tput cup 0 0
		# 	printf '\033[23;0t' # Restore title from stack
		# fi
	elif [[ "$(uname)" == 'Darwin' ]] || [[ "${TERM_PROGRAM}" = 'Apple_Terminal' ]] || [[ "${TERM_PROGRAM}" = 'iTerm.app' ]]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [[ -x "$(which tput)" ]]; then
		tput reset
	elif [[ -x "$(which reset)" ]]; then
		reset
	else
		clear
		# alias cls="clear; printf '\33[3J'"
		# echo -ne '\033]50;ClearScrollback\a' # For iTerm2
	fi

