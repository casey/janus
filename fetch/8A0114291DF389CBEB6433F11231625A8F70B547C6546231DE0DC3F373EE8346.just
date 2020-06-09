test tag="latest":
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -p 8022:22 \
        -v $PWD:/app \
        -v vscode-server:/root/.vscode-server \
        -e WEB_ROOT=/app \
        -e WS_FIXED=1 \
        -v $PWD/id_ed25519.pub:/etc/authorized_keys/root \
        -v $PWD/services.d/watcher/run:/etc/services.d/watcher/run \
        nnurphy/or

#-v $PWD/nginx-site.conf:/etc/openresty/conf.d/default.conf \