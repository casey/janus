build:
    docker build . -t nnurphy/phpf:7.2 --progress=plain \
        --build-arg s6url=http://172.178.1.204:2015/s6-overlay-amd64.tar.gz \
        --build-arg php_url=http://172.178.1.204:2015/php-7.2.24.tar.xz \
        --build-arg wstunnel_url=http://172.178.1.204:2015/tools/wstunnel_linux_x64

info:
    docker run --rm \
        --name=test \
        -p 8088:80 \
        -p 9002:22 \
        -v vscode-server-php:/root/.vscode-server \
        -v $(pwd)/index.php:/srv/index.php \
        phpf:7.2

test:
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -v vscode-server-php:/root/.vscode-server \
        -v $(pwd)/id_ecdsa.php.pub:/root/.ssh/authorized_keys \
        nnurphy/phpf:7.2

# wstunnel -L 2223:127.0.0.1:80 ws://127.0.0.1:80 --upgradePathPrefix=wstunnel-S6cHCQuPtVubM

wsc:
    docker run --rm \
        --name=wsc \
        -e SRV=ws://172.178.5.21:8090 \
        -p 8899:8080 \
        wstunnel 0.0.0.0:8080:127.0.0.1:80 --upgradePathPrefix=wstunnel-ldljWkuBLwUMn

k8sc token:
    docker run --rm \
        --name=wsc \
        -p 2233:8080 \
        wstunnel -L 0.0.0.0:8080:127.0.0.1:22 ws://172.178.5.21:8090 --upgradePathPrefix=wstunnel-{{token}}

debug:
    docker run --rm -it \
        --network=container:test \
        --pid=container:test \
        deb
