VIM := `which nvim || which vim`

# Install Super Sayain Vim
install: 
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/backup
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/session
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/swap
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/tags
	mkdir -vp {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim/undo
	{{VIM}} -c 'PackUpdate'
	{{VIM}} -c 'CocInstall -sync coc-snippets coc-pairs coc-git coc-highlight coc-yank coc-explorer coc-word coc-syntax coc-dictionary coc-tag|q'

# Update Super Sayain Vim
update:
    @git pull --ff --ff-only;

# Same as Update
@upgrade: update

# Unistall Super Sayain Vim
uninstall:
	rm -rf {{env_var_or_default('XDG_CACHE_HOME', '$HOME/.cache')}}/vim

