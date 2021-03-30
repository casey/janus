cp cfg="~/pub/Configuration":
    rm -rf home
    mkdir -p home/.config/nvim
    cp -R {{cfg}}/_zshrc home/.zshrc
    cp -R {{cfg}}/.zshrc.d home/.zshrc.d
    cp -R {{cfg}}/_vimrc home/.config/nvim/init.vim
    cp -R {{cfg}}/_tmux.conf home/.tmux.conf

nwss:
    docker build . -t nnurphy/deb:nwss -f Dockerfile-nwss

test:
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -p 2255:22 \
        -v $(pwd):/app \
        -v $PWD/entrypoint.sh:/entrypoint.sh \
        -v vscode-server:/root/.vscode-server \
        -e WS_FIXED=1 \
        -e SSH_ENABLE_ROOT=true \
        -v $(pwd)/../key.pub:/root/.ssh/authorized_keys \
        nnurphy/deb:nwss

wasmtime:
    docker build . \
        -t wasmtime \
        -f Dockerfile-wasmtime \
        --build-arg wasmtime_url=http://172.178.1.204:2015/wasmtime-dev-x86_64-linux.tar.xz

login:
    ssh -v -i id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2233 -o IdentitiesOnly=yes root@localhost