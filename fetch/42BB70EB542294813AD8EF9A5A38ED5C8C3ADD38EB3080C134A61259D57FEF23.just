cp cfg="~/pub/Configuration":
    rm -rf home
    mkdir -p home/.config/nvim
    cp -R {{cfg}}/_zshrc home/.zshrc
    cp -R {{cfg}}/.zshrc.d home/.zshrc.d
    cp -R {{cfg}}/_vimrc home/.config/nvim/init.vim
    cp -R {{cfg}}/_tmux.conf home/.tmux.conf


test:
    docker run --rm \
        -v $PWD/id_ed25519.pub:/etc/authorized_keys/root \
        -p 2234:22 \
        -e SSH_ENABLE_ROOT=true \
        -v $PWD/entrypoint.sh:/entrypoint.sh \
        apk sshd

login:
    ssh -i id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2234 -o IdentitiesOnly=yes root@localhost