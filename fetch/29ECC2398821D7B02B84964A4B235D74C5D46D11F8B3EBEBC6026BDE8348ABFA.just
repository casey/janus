cp cfg="~/pub/Configuration":
    rm -rf home
    mkdir -p home/.config/nvim
    cp -R {{cfg}}/_zshrc home/.zshrc
    cp -R {{cfg}}/.zshrc.d home/.zshrc.d
    cp -R {{cfg}}/_vimrc home/.config/nvim/init.vim
    cp -R {{cfg}}/_tmux.conf home/.tmux.conf

