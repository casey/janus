install:
    @echo "Installing all the things..."

vim-clean:
    rm $HOME/.vimrc
    rm -rf $HOME/.vim

vim-init: vim-clean
    mkdir -p $HOME/.vim/autoload
    mkdir -p $HOME/.vim/colors

vim-plug: vim-init
    curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim-copy: vim-plug
    cp vimrc $HOME/.vimrc
    cp vim/mappings.vim $HOME/.vim/mappings.vim
    cp vim/plugins.vim $HOME/.vim/plugins.vim
    cp vim/colors/nord.vim $HOME/.vim/colors/nord.vim

vim-plug-install: vim-copy
    vim +PlugInstall +qall

vim: vim-plug-install
    @echo "Vim config set up"

fish-functions:

fish: fish-functions
    @echo "Fish set up"
