v := "0.2.5"
os := "x86_64-unknown-linux-gnu"

# Install Super Sayain Vim
install: _initialize _venv _web _pack
	#!/bin/bash
	if ! hash cargo 2>/dev/null; then
		echo "Rust installation not found."
		exit 1
	fi
	cargo install --git https://github.com/Th3Whit3Wolf/pquote
	if ! hash node 2>/dev/null; then
		echo "nodejs installation not found."
		exit 1
	fi
	echo "Super Saiyan Vim Installed Sucessfully"

_initialize: 
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/backup
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/session
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/swap
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/tags
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/undo
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/venv
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/lsp

_init_pack:
	#!/usr/bin/bash
	if ! hash pack 2>/dev/null; then
		wget https://github.com/maralla/pack/releases/download/v{{v}}/pack-v{{v}}-{{os}}.tar.gz
		tar -vxf pack-v{{v}}-{{os}}.tar.gz
		sudo mv pack /usr/bin/
		sudo rm -dR contrib
		rm LICENSE
		rm pack-v{{v}}-{{os}}.tar.gz
		rm README.md
		echo "export VIM_CONFIG_PATH=$HOME/.cache/vim" >> ~/.zprofile
		echo "export VIM_CONFIG_PATH=$HOME/.cache/vim" >> ~/.profile
		VIM_CONFIG_PATH=$HOME/.cache/vim
	elif [[ "$(pack -V | cut -d ' ' -f2 | cut -d '.' -f3)" < "$(echo {{v}} | cut -d '.' -f3)" ]] || [[ "$(pack -V | cut -d ' ' -f2 | cut -d '.' -f2)" < "$(echo {{v}} | cut -d '.' -f2)" ]] || [[ "$(pack -V | cut -d ' ' -f2 | cut -d '.' -f1)" < "$(echo {{v}} | cut -d '.' -f1)" ]]; then
		wget https://github.com/maralla/pack/releases/download/v{{v}}/pack-v{{v}}-{{os}}.tar.gz
		tar -vxf pack-v{{v}}-{{os}}.tar.gz
		sudo mv pack /usr/bin/
		sudo rm -dR contrib
		rm LICENSE
		rm pack-v{{v}}-{{os}}.tar.gz
		rm README.md
	fi

# Update Super Sayain Vim
update:
	@git pull --ff --ff-only
	@pack update

# Same as Update
@upgrade: update

# Unistall Super Sayain Vim
uninstall:
	rm -rf {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim

# Setup Python2 Virtual Environment
venv2:
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

# Setup Python3 Virtual Environment
_venv:
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
			mccabe \
			isort \
			jedi \
			rope \
			pycodestyle \
			nodeenv \
			'python-language-server[all]'
	fi

# Install Web
_web:
	#!/usr/bin/env bash
	echo -e '\n:: Nodejs'
	if [ -x "$(command -v yarn)" ]; then
		yarn global add neovim
	elif [ -x "$(command -v npm)" ]; then
		npm install -g neovim
	else	
		echo "Please install yarn or npm"
		return 1
	fi
		#$js_install \
		#neovim 
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

# Install all packages
_pack: _init_pack
	#!/usr/bin/bash
	install() {
		if [ ! -z "$2" ]; then
			if [ ! -d "$(echo ~/.cache/vim/pack/default/opt/$(echo $1 | cut -d '/' -f2 ))" ]; then
				pack install $@
			else
				echo "$1 is already installed as lazily loaded"
			fi
		else
			if [ ! -d "$(echo ~/.cache/vim/pack/default/start/$(echo $1 | cut -d '/' -f2 ))" ]; then
				pack install $1
			else
				echo "$1 is already installed"
			fi
		fi
	}
	###########
	# General #
	###########
	install() liuchengxu/vim-clap
	install() Shougo/echodoc
	install() ryanoasis/vim-devicons
	install() mhinz/vim-signify
	install() Th3Whit3Wolf/vim-shebang
	install() hardcoreplayers/dashboard-nvim
	
	install() skywind3000/asyncrun.vim -o
	install() honza/vim-snippets -o
	install() tpope/vim-endwise -o
	install() tpope/vim-eunuch -o
	install() alvan/vim-closetag -o
	install() neoclide/coc.nvim --build 'yarn install --frozen-lockfile' -o
	install() lambdalisue/gina.vim -o
	install() liuchengxu/vista.vim -o
	install() alok/rainbow_parentheses.vim --build 'git checkout fix-spell' -o
	install() ludovicchabant/vim-gutentags -o
	install() liuchengxu/vim-which-key -o
	install() rhysd/git-messenger.vim -o
	install() tpope/vim-eunuch -o

	############
	# Language #
	############
	install() sheerun/vim-polyglot
	
	install() euclio/vim-markdown-composer --build 'cargo build --release' -o
	install() mhinz/vim-crates -o
	install() turbio/bracey.vim -o
	install() arzg/vim-rust-syntax-ext -o

	#install() cespare/vim-toml --for toml
	#install() numirias/semshi --for python
