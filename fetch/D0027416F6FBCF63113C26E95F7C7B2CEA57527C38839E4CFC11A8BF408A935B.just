VIM := `which nvim || which vim`
VIM_VERSION := `$(which nvim || which vim) --version`

# Install Super Sayain Vim
install: _initital _venv _linter _dein-update
	

# Update Super Sayain Vim
update: _git _venv _linter _dein-update

# Same as Update
@upgrade: update

# Unistall Super Sayain Vim
uninstall:
	rm -rf {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim

_dein-update:
    @{{VIM}} --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE -c "try | call dein#clear_state() | call dein#update() | call dein#recache_runtimepath() | finally | call confirm('') | qall! | endtry"	

_initital:
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/backup
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/session
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/swap
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/tags
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/undo; {{VIM}} --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE -c "try | call dein#update() | finally | call confirm('') | qall! | endtry"

_git:
    @git pull --ff --ff-only;

_venv:
    #!/usr/bin/env bash
    venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"

    # Try to detect python2/3 executables
    if ! hash python2 2>/dev/null; then
        echo "Python2 installation not found."
        exit 1
    elif ! hash python3 2>/dev/null; then
        echo "Python3 installation not found."
        exit 1
    fi

    # Ensure python 2/3 virtual environments
    [ -d "$venv" ] || mkdir -p "$venv"
    if hash pyenv 2>/dev/null && [ -d "$(pyenv root)/versions/neovim2" ] && [ -d "$(pyenv root)/versions/neovim3" ]; then
        # pyenv environments are setup so use them
        [ -d "$venv/neovim2" ] || ln -s "$(pyenv root)/versions/neovim2" "$venv/neovim2"
        [ -d "$venv/neovim3" ] || ln -s "$(pyenv root)/versions/neovim3" "$venv/neovim3"
    else
        [ -d "$venv/neovim2" ] || python2 -m virtualenv "$venv/neovim2"
        [ -d "$venv/neovim3" ] || python3 -m venv "$venv/neovim3"
    fi

    # Install or upgrade dependencies
    echo ':: PYTHON 2'
    "$venv/neovim2/bin/pip" install -U pynvim PyYAML
    echo -e '\n:: PYTHON 3'
    if [ -x "venv/neovim3/bin/pip3" ]; then
        "$venv/neovim3/bin/pip3" install -U pynvim PyYAML Send2Trash
    else
        "$venv/neovim3/bin/pip3" install -U pynvim PyYAML Send2Trash
    fi

# Check for Language Servers and Configure (neo)vim for them
_linter:
    #!/usr/bin/env bash

    START=$(date +%s.%6N)
    linter_list_loc="${HOME}/.config/nvim/config/plugins/checker.vim"

    lacksString() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 1; done
    return 0
    }

    hasString() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
    }

    getLCNSC() {
        lsp="$1"
        string=""
        case "${lsp}" in
            ccls)
                cat >> "$linter_list_loc" << EOL
    \ 'c': ['${lsp}', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['${lsp}', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['${lsp}', '--log-file=/tmp/cc.log'],
    \ 'objc': ['${lsp}', '--log-file=/tmp/cc.log'],
    EOL
            ;;
            'ccls-clangd')
                cat >> "$linter_list_loc" << EOL
    \ 'c': ['ccls}', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objcpp': ['clangd'],
    EOL
            ;;
            'ccls-cquery')
                cat >> "$linter_list_loc" << EOL
    \ 'c': ['ccls}', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objcpp': ['cquery}', '--log-file=/tmp/cq.log'],
    EOL
            ;;
            cquery)
                cat >> "$linter_list_loc" << EOL
    \ 'c': ['${lsp}', '--log-file=/tmp/cq.log'],
    \ 'cpp': ['${lsp}', '--log-file=/tmp/cq.log'],
    \ 'objc': ['${lsp}', '--log-file=/tmp/cq.log'],
    \ 'objcpp': ['${lsp}', '--log-file=/tmp/cq.log'],
    EOL
            ;;
            clangd)
                cat >> "$linter_list_loc" << EOL
    \ 'cpp': ['${lsp}'],
    \ 'objcpp': ['${lsp}', '--log-file=/tmp/cq.log'],
    EOL
            ;;
            'OmniSharp.exe')
                cat >> "$linter_list_loc" << EOL
    \ 'cs': ['mono', '/opt/omnisharp-roslyn/OmniSharp.exe', '--languageserver'],
    EOL
            ;;
            'css-languageserver')
                cat >> "$linter_list_loc" << EOL
    \ 'css': ['${lsp}', '--stdio'],
    \ 'less': ['${lsp}', '--stdio'],
    \ 'sass': ['${lsp}', '--stdio'],
    \ 'scss': ['${lsp}', '--stdio'],
    EOL
            ;;
            'clojure-lsp')
                cat >> "$linter_list_loc" << EOL
    \ 'clojure': ['${lsp}'],
    EOL
            ;;
            'serve-d')
                cat >> "$linter_list_loc" << EOL
    \ 'd': ['${lsp}', '--stdio'],
    EOL
            ;;
            dls)
                cat >> "$linter_list_loc" << EOL
    \ 'd': ['${lsp}', '--stdio'],
    EOL
            ;;
            '~/.pub-cache/bin/dart_language_server')
                cat >> "$linter_list_loc" << EOL
    \ 'dart': ['${lsp}'],
    EOL
            ;;
            'docker-langserver')
                cat >> "$linter_list_loc" << EOL
    \ 'docker': ['${lsp}', '--stdio'],
    EOL
            ;;
            'elixir-ls')
                cat >> "$linter_list_loc" << EOL
    \ 'elixir': ['mix.exs'],
    EOL
            ;;
            sourcer)
                cat >> "$linter_list_loc" << EOL
    \ 'erlang': ['erlang_ls', '--symbol_skip_mem', '--incrmental_sync', '--autocomplete_no_prefix'],
    EOL
            ;;
            fortls)
                cat >> "$linter_list_loc" << EOL
    \ 'fortran': ['${lsp}', '--symbol_skip_mem', '--incrmental_sync', '--autocomplete_no_prefix'],
    EOL
            ;;
            glslls)
                cat >> "$linter_list_loc" << EOL
    \ 'glsl': ['${lsp}', '--stdin'],
    EOL
            ;;
            bingo)
                cat >> "$linter_list_loc" << EOL
    \ 'go': ['${lsp}'],
    EOL
            ;;
            'go-langserver')
                cat >> "$linter_list_loc" << EOL
    \ 'go': ['${lsp}'],
    EOL
            ;;
            'gopls')
                cat >> "$linter_list_loc" << EOL
    \ 'go': ['${lsp}'],
    EOL
            ;;
            hie)
                cat >> "$linter_list_loc" << EOL
    \ 'haskell': ['${lsp}', '--lsp'],
    EOL
            ;;
            'html-languageserver')
                cat >> "$linter_list_loc" << EOL
    \ 'html': ['${lsp}'],
    EOL
            ;;
            vsce)
                cat >> "$linter_list_loc" << EOL
    \ 'java': ['${lsp}'],
    EOL
            ;;
            'java-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'java': ['${lsp}', '--quiet'],
    EOL
            ;;
            'typescript-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['${lsp}', 'start'],
    \ 'typescript.jsx': ['${lsp}', 'start'],
    EOL
            ;;
            'flow-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'javascript': ['${lsp}'],
    EOL
            ;;
            'json-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'json': ['${lsp}', '--stdio'],
    EOL
            ;;
            julia)
                cat >> "$linter_list_loc" << EOL
    \  '${lsp}': ['${lsp}', '--startup-file=no', '--history-file=no', '-e', '
    \     using LanguageServer;
    \     using Pkg;
    \     import StaticLint;
    \     import SymbolServer;
    \     env_path = dirname(Pkg.Types.Context().env.project_file);
    \     debug = false;
    \
    \     server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "", Dict());
    \     server.runlinter = true;
    \     run(server);
    \  '],
    EOL
            ;;
            'kotlin-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'kotlin': ['${lsp}', '--quiet'],
    EOL
            ;;
            'lua-lsp')
                cat >> "$linter_list_loc" << EOL
    \ 'lua': ['${lsp}'],
    EOL
            ;;
            'ocaml-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'ocaml': ['${lsp}', '--stdio'],
    \ 'reason': ['${lsp}', '--stdio'],
    EOL
            ;;
            'php-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'php': ['${lsp}'],
    EOL
            ;;
            'puppet-languageserver')
                cat >> "$linter_list_loc" << EOL
    \ 'puppet': ['${lsp}', '--stdio'],
    EOL
            ;;
            'purescript-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'purescript': ['${lsp}', '--stdio'],
    EOL
            ;;
            pyls)
                cat >> "$linter_list_loc" << EOL
    \ 'python': ['${lsp}'],
    EOL
            ;;
            orbaclerun)
                cat >> "$linter_list_loc" << EOL
    \ 'ruby': ['${lsp}', 'file-server'],
    EOL
            ;;
            solargraph)
                cat >> "$linter_list_loc" << EOL
    \ 'ruby': ['${lsp}', 'stdio'],
    EOL
            ;;
            rls)
                cat >> "$linter_list_loc" << EOL
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'beta', '${lsp}'],
    EOL
            ;;
            ra_lsp_server)
                cat >> "$linter_list_loc" << EOL
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'beta', '${lsp}'],
    EOL
            ;;
            'bash-language-server')
                cat >> "$linter_list_loc" << EOL
    \ 'sh': ['${lsp}', 'start'],
    EOL
            ;;
            vls)
                cat >> "$linter_list_loc" << EOL
    \ 'vue': ['${lsp}'],
    EOL
            ;;
            *)
            echo "$lsp" "found"
            ;;
        esac
    }

    LSP[1]='bash-language-server'
    LSP[2]='ccls'
    LSP[3]='clojure-lsp'
    LSP[4]='css-languageserver'
    LSP[5]='dart_language_server'
    LSP[6]='~/.pub-cache/bin/dart_language_server'
    LSP[7]='docker-langserver'
    LSP[8]='elixir-ls'
    LSP[9]='fortls'
    LSP[10]='glslls'
    LSP[11]='gopls'
    LSP[12]='hie'
    LSP[13]='html-languageserver'
    LSP[14]='json-language-server'
    LSP[15]='julia'
    LSP[16]='kotlin-language-server'
    LSP[17]='lua-lsp'
    LSP[18]='merlin'
    LSP[19]='nimlsp'
    LSP[20]='ocaml-language-server'
    LSP[21]='OmniSharp.exe'
    LSP[22]='orbaclerun'
    LSP[23]='php-language-server'
    LSP[24]='puppet-languageserver'
    LSP[25]='purescript-language-server'
    LSP[26]='pyls'
    LSP[27]='ra_lsp_server'
    LSP[28]='sbtserver'
    LSP[29]='serve-d'
    LSP[30]='solargraph'
    LSP[31]='sourcer'
    LSP[32]='typescript-language-server'
    LSP[33]='vls'
    LSP[34]='vsce'

    Installed=()

    echo "---------------------------------------------------------------------------------------------"
    echo "                         * Looking For Language Servers *                         "
    echo "---------------------------------------------------------------------------------------------"

    for lsp in "${LSP[@]}"
    do
        hash $lsp 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Found" $lsp
            Installed+=("${lsp}")
        fi
    done

    echo "---------------------------------------------------------------------------------------------"
    echo "                     * Looking for Backup Language Servers *                      "
    echo "---------------------------------------------------------------------------------------------"

    lacksString "ccls" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "cquery" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo  "Found cquery"
            Installed+=("cquery")
        else
            hash "clangd" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo  "clangd is installed"
                Installed+=("clangd")
            fi
        fi
    fi

    lacksString "serve-d" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "dls" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo  "Found dls"
            Installed+=("dls")
        fi
    fi

    lacksString "ra_lsp_server" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "rls" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo  "Found dls"
            Installed+=("dls")
        fi
    fi

    lacksString "typescript-language-server" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "flow-language-server" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo  "Found flow language server"
            Installed+=("flow-language-server")
        fi
    fi

    lacksString "gopls" "${Installed[@]}"
        if [ $? -eq 0 ]; then
            hash "bingo" 2>/dev/null
        if [ $? -eq 0 ]; then
            hash "go-langserver" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo  "Found go language server"
                Installed+=("go-langserver")
            fi
        fi
    fi

    lacksString "vsce" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "java-language-server" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo  "Found java language server"
            Installed+=("java-language-server")
        fi
    fi

    hasString "ccls" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "clangd" 2>/dev/null
        if [ $? -eq 0 ]; then
            for i in "${!Installed[@]}"; do
                if [[ ${Installed[$i]} == "ccls" ]]; then
                    Installed[$i]="ccls-clangd"
                    echo "Found clangd"
                fi
            done
        fi
    fi

    hasString "ccls" "${Installed[@]}"
    if [ $? -eq 0 ]; then
        hash "cquery" 2>/dev/null
        if [ $? -eq 0 ]; then
            for i in "${!Installed[@]}"; do
                if [[ ${Installed[$i]} == "ccls" ]]; then
                    Installed[$i]="ccls-cquery"
                    echo "Found cquery"
                fi
            done
        fi
    fi

    echo "---------------------------------------------------------------------------------------------"
    echo "                          * Found All Language Servers *                          "
    echo "---------------------------------------------------------------------------------------------"

    cat > "$linter_list_loc" << EOL
    let g:ale_linters = {
    \ 'ada': ['gcc'],
    \ 'ansible': ['ansible-lint'],
    \ 'apiblueprint': ['drafter'],
    \ 'asciidoc': ['alex'],
    \ 'asm': ['gcc'],
    \ 'awk': ['gawk'],
    \ 'bash': ['shfmt'],
    \ 'bibtex': ['bibclean'],
    \ 'c': ['clangd', 'clang', 'clang-format', 'clang-tidy', 'cppcheck', 'cpplint', 'gcc', 'flawfinder', 'uncrustify'],
    \ 'chef': ['foodcritic'],
    \ 'cloudformation': ['cfn-python-lint'],
    \ 'cmake': ['cmake-format', 'cmakelint'],
    \ 'coffeescript': ['coffeelint', 'coffee'],
    \ 'cpp': ['clangd', 'clang', 'clang-format', 'clang-tidy', 'cppcheck', 'cpplint', 'gcc', 'flawfinder', 'uncrustify', 'clazy'],
    \ 'crystal': ['ameba'],
    \ 'cs': ['mcs', 'mcsc', 'uncrustify'],
    \ 'css': ['csslint', 'prettier', 'stylelint'],
    \ 'cucumber': ['cucumber'],
    \ 'cuda': ['nvcc'],
    \ 'clojure': ['joker'],
    \ 'd': ['uncrustify', 'dmd'],
    \ 'dafny': ['dafny'],
    \ 'dart': ['dartanalyzer', 'dartfmt'],
    \ 'docker': ['hadolint', 'dockerfile_lint'],
    \ 'elixir': ['credo', 'dogma', 'dialyxir', 'mix'],
    \ 'elm': ['elm-format', 'elm-make'],
    \ 'erlang': ['SyntaxErl', 'erlc'],
    \ 'fortran': ['gcc'],
    \ 'fountain': ['proselint'],
    \ 'fusionscript': ['fusion-lint'],
    \ 'gitcommit': ['gitlint'],
    \ 'glsl': ['glslang'],
    \ 'go': ['staticcheck', 'gometalinter', 'go vet', 'go build'],
    \ 'graphql': ['gqlint', 'prettier', 'eslint'],
    \ 'hack': ['hack', 'hhast'],
    \ 'haml': ['haml-lint'],
    \ 'handlebars': ['ember-template-lint'],
    \ 'haskell': ['stylish-haskell', 'hlint', 'ghc', 'hfmt', 'brittany'],
    \ 'html': ['tidy', 'prettier', 'alex', 'proselint', 'write-good'],
    \ 'hcl': ['terraform-fmt'],
    \ 'java': ['javac', 'google-java-format', 'uncrustify', 'checkstyle'],
    \ 'javascript': ['xo', 'eslint', 'prettier', 'jscs'],
    \ 'json': ['fixjson', 'jq', 'prettier'],
    \ 'jsx': ['stylelint', 'eslint'],
    \ 'kotlin': ['ktlint', 'kotlinc'],
    \ 'latex': ['textlint', 'proselint', 'write-good'],
    \ 'less': ['prettier', 'stylelint', 'lessc'],
    \ 'lua': ['luac', 'luacheck'],
    \ 'make': ['checkmake'],
    \ 'markdown': ['alex', 'markdownlint', 'mdl', 'prettier', 'proselint', 'redpen', 'remark-lint', 'textlint', 'vale', 'write-good'],
    \ 'matlab': ['mlint'],
    \ 'mercury': ['mmc'],
    \ 'nim': ['nim check '],
    \ 'objc': ['clang', 'clangd', 'uncrustify'],
    \ 'objcpp': ['clang', 'clangd', 'uncrustify'],
    \ 'ocaml': ['ols', 'ocamlformat', 'merlin'],
    \ 'nix': ['nix-instantiate'],
    \ 'nroff': ['alex', 'proselint', 'write-good'],
    \ 'pawn': ['uncrustify'],
    \ 'perl': ['perl -c', 'perl-critic', 'perltidy'],
    \ 'perl6': ['perl6 -c'],
    \ 'php': ['phan', 'phpcbf', 'phpcs', 'php-cs-fixer', 'php -l', 'phpmd', 'phpstan', 'phpsalm'],
    \ 'po': ['alex', 'msgfmt', 'proselint', 'write-good'],
    \ 'pony': ['ponyc'],
    \ 'pod': ['alex', 'proselint', 'write-good'],
    \ 'prolog': ['swipl'],
    \ 'proto': ['protoc-gen-lint'],
    \ 'pug': ['pug-lint'],
    \ 'puppet': ['puppet', 'puppet-lint', 'puppet-languageserver'],
    \ 'python': ['autopep8', 'yapf', 'flake8'],
    \ 'qml': ['qmllint', 'qmlfmt'],
    \ 'r': ['lintr'],
    \ 'racket': ['raco'],
    \ 'review': ['redpen'],
    \ 'reason': ['ols', 'refmt', 'merlin'],
    \ 'rpmspec': ['rpmlint'],
    \ 'ruby': ['brakeman', 'reek', 'rubocop', 'ruby', 'rufo', 'standardrb', 'rails_best_practices'],
    \ 'rust': ['cargo', 'rustc', 'rustfmt'],
    \ 'rst': ['alex', 'proselint', 'redpen', 'rstcheck', 'textlint', 'vale', 'write-good'],
    \ 'sass': ['sass-lint', 'stylelint'],
    \ 'scala': ['fsc', 'sbtserver', 'scalac', 'scalastyle', 'scalafmt'],
    \ 'slim': ['slim-lint'],
    \ 'sml': ['smlnj'],
    \ 'solidity': ['solhint', 'solium'],
    \ 'sql': ['sqlint', 'sqlfmt'],
    \ 'stylus': ['stylelint'],
    \ 'sugarss': ['stylelint'],
    \ 'swift': ['swiftlint', 'swiftformat'],
    \ 'tcl': ['nagelfar'],
    \ 'texinfo': ['alex', 'proselint', 'write-good'],
    \ 'thrift': ['thrift'],
    \ 'typescript': ['tsserver', 'tslint', 'prettier', 'eslint'],
    \ 'vala': ['uncrustify'],
    \ 'verilog': ['iverilog', 'verilator', 'vlog', 'xvlog'],
    \ 'vhdl': ['ghdl', 'vcom', 'xvhdl'],
    \ 'vim': ['vint'],
    \ 'vue': ['prettier'],
    \ 'xhtml': ['alex', 'proselint', 'write-good'],
    \ 'xml': ['xmllint'],
    \ 'yaml': ['prettier', 'swaglint', 'yamllint'],
    \ }

    highlight ALEWarning ctermbg=DarkMagenta
    highlight ALEErrorSign ctermbg=DarkMagenta
    let g:ale_sign_error            = '>>'
    let g:ale_sign_warning          = '--'
    let g:ale_sign_error            = '✖'
    let g:ale_sign_warning          = '⚡'
    let g:ale_echo_msg_format       = 'ALE(%severity%): [%linter%] %s'
    let g:ale_echo_msg_error_str    = 'E'
    let g:ale_echo_msg_warning_str  = 'W'
    EOL

    if [ -z "$Installed" ]; then
        echo "There are no Language Servers Installed..."
        echo "Langauge Servers are part of what makes SS-Vim awesome"
        echo "For maximum awesomeness please install your favorite language's Language Server"
    else
        echo "Any edits to" $linter_list_loc "will be overridden on update."
        echo "This file only contains info about ALE and LanguageClient Neovim."
        echo "Please create an issue if there's something you'd like to see in there that isn't currently."
        echo "https://github.com/TheWhiteWolf1337/SS-Vim/issues/new"
        cat >> "$linter_list_loc" << EOL


    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_rootMarkers = {
    \ 'cpp':            ['main.cpp', 'build', 'compile_commands.json'],
    \ 'cs':             ['.git', '*.csproj'],
    \ 'go':             ['.git', 'go.mod'],
    \ 'haskell':        ['*.cabal', 'stack.yaml'],
    \ 'javascript':     ['project.json'],
    \ 'rust':           ['Cargo.toml']
    \ }

    let g:LanguageClient_diagnosticsDisplay = {
    \   1: {
    \        "name": "Error",
    \        "texthl": "ALEError",
    \        "signText": "✖",
    \        "signTexthl": "ALEErrorSign",
    \        "virtualTexthl": "Error",
    \    },
    \        2: {
    \       "name": "Warning",
    \        "texthl": "ALEWarning",
    \        "signText": "⚡",
    \        "signTexthl": "ALEWarningSign",
    \        "virtualTexthl": "Todo",
    \    },
    \    3: {
    \        "name": "Information",
    \        "texthl": "ALEInfo",
    \        "signText": "ℹ",
    \        "signTexthl": "ALEInfoSign",
    \        "virtualTexthl": "Todo",
    \    },
    \    4: {
    \        "name": "Hint",
    \        "texthl": "ALEInfo",
    \        "signText": "➤",
    \        "signTexthl": "ALEInfoSign",
    \        "virtualTexthl": "Todo",
    \   },
    \}

    let g:LanguageClient_rootMarkers = {
    EOL
        for i in "${Installed[@]}"; do
            getLCNSC "${i}"
        done

        cat >> "$linter_list_loc" << EOL
    \ }
    EOL
    echo "---------------------------------------------------------------------------------------------"
    echo "                              * Adding Language Servers to Vim *                             "
    echo "---------------------------------------------------------------------------------------------"
    fi

    END=$(date +%s.%6N)
    DIFF=$(echo "scale=3; ($END - $START) * 1000"| bc -l )
    X=$(printf "%.3f" $DIFF)
    echo "It took ${X%.*} miloseconds to complete this task..."

    # let Settings_path = $VIMPATH.'/misc/ccls.json'
    # let Settings_path = $VIMPATH.'/misc/rust.json'
    # let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
    # let g:LanguageClient_settingsPath = fnameescape(Settings_path)
