VIM := `which nvim || which vim`
NPM := `which yarn || which npm`


# Install Super Sayain Vim
install: initialize venv
	echo "Super Saiyan Vim Installed Sucessfully"

initialize: 
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/backup
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/session
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/swap
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/tags
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/undo
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/venv
	{{VIM}} -c 'PackUpdate'

# Update Super Sayain Vim
update:
    @git pull --ff --ff-only;

# Same as Update
@upgrade: update

# Unistall Super Sayain Vim
uninstall:
	rm -rf {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim

_venv2:
	#!/usr/bin/env bash
	venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"
	# Try to detect python2/3 executables
	if ! hash python2 2>/dev/null; then
		echo "Python2 installation not found."
		exit 1
	fi
	# Create Python Virtual Environment
	# Ensure python 2 virtual environments
	[ -d "$venv" ] || mkdir -p "$venv"
	if hash pyenv 2>/dev/null && [ -d "$(pyenv root)/versions/neovim2" ]; then
		# pyenv environments are setup so use them
		[ -d "$venv/neovim2" ] || ln -s "$(pyenv root)/versions/neovim2" "$venv/neovim2"
	else
		[ -d "$venv/neovim2" ] || python2 -m virtualenv "$venv/neovim2"
	fi
	if ! hash python2 2>/dev/null; then
		echo "for Python 2 support install python 2 and python 2 pip and run just venv"
	else
		echo ":: PYTHON 2"
		"$venv/neovim2/bin/pip" install -U \
			pynvim \
			yapf \
			autopep8 \
			pylint \
			flake8 \
			pylama
	fi

# Setup virtual environments for python
venv:
	#!/usr/bin/env bash
	venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"
	if ! hash python3 2>/dev/null; then
		echo "Python3 installation not found."
		exit 1
	fi
	# Create Python Virtual Environment
	# Ensure python 3 virtual environments
	[ -d "$venv" ] || mkdir -p "$venv"
	if hash pyenv 2>/dev/null && [ -d "$(pyenv root)/versions/neovim3" ]; then
		# pyenv environments are setup so use them
		[ -d "$venv/neovim3" ] || ln -s "$(pyenv root)/versions/neovim3" "$venv/neovim3"
	else
		[ -d "$venv/neovim3" ] || python3 -m venv "$venv/neovim3"
	fi

		if ! hash python3 2>/dev/null; then
		echo "for Python 3 support install python 3 and python 3 pip and run just venv"
	else
		echo -e '\n:: PYTHON 3'
		"$venv/neovim3/bin/pip" install -U \
			pynvim \
			yapf \
			autopep8 \
			pylint \
			prospector \
			flake8 \
			pylama \
			mypy \
			isort \
			jedi \
			rope \
			nodeenv
	fi

web:
	#!/usr/bin/env bash
	echo -e '\n:: Nodejs'
	if [ -x "$(command -v npm)" ]; then
		js_install="npm install -g"
	elif [ -x "$(command -v yarn)" ]; then
		js_install="yarn global add"
	else	
		echo "Please install yarn or npm"
		return 1
	fi
		$js_install \
		neovim 
		#bash-language-server
		#eslint \
		#prettier \
		#eslint-config-prettier \
		#eslint-plugin-prettier \
		#ts-node \
		#tslint \
		#typescript \
		#tern \
		#jshint \
		#jsxhint \ 
		#jsonlint \
		#stylelint \
		#sass-lint \
		#raml-cop \
		#markdownlint-cli \
		#write-good \
		#eslint-cli
