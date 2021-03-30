build version="7.2":
    docker build . -t nnurphy/phpf:{{version}} \
        -f Dockerfile-{{version}} \
        --build-arg php_version={{version}}

t profile="1":
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -e WEB_ROOT=/app \
        -e PHP_DEBUG={{profile}} \
        -e WS_FIXED=1 \
        -e PHP_FPM_SERVERS=5,25 \
        -e XDEBUG_SESSION=xdebug_suck \
        -v $(pwd)/setup-php:/setup-php \
        -v $(pwd)/id_ed25519.pub:/etc/authorized_keys/root \
        -v $(pwd)/index.php:/app/index.php \
        -v $PWD/index.php:/srv/index.php \
        nnurphy/phpf:7.2

build-gcc:
    docker build . -t nnurphy/phpf:7.2 -f Dockerfile-gcc \
        --build-arg s6url=http://172.178.1.204:2015/s6-overlay-amd64.tar.gz \
        --build-arg php_url=http://172.178.1.204:2015/php-7.2.24.tar.xz \
        --build-arg wstunnel_url=http://172.178.1.204:2015/tools/wstunnel_linux_x64


test profile="1":
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -e WEB_ROOT=/app \
        -e PHP_DEBUG={{profile}} \
        -e WS_FIXED=1 \
        -e PHP_FPM_SERVERS=5,25 \
        -v vscode-server-php:/root/.vscode-server \
        -v $(pwd)/id_ed25519.pub:/etc/authorized_keys/root \
        -v $(pwd)/index.php:/app/index.php \
        -v $(pwd)/log:/var/log/xdebug \
        -v $PWD/index.php:/srv/index.php \
        nnurphy/phpf:7.4u

# wstunnel -L 2223:127.0.0.1:80 ws://127.0.0.1:80 --upgradePathPrefix=wstunnel-S6cHCQuPtVubM

k8sc token:
    docker run --rm \
        --name=wsc \
        -p 2233:8080 \
        wstunnel -L 0.0.0.0:8080:127.0.0.1:22 ws://172.178.5.21:8090 --upgradePathPrefix=wstunnel-{{token}}

profile:
    docker run --rm \
        --name php-profile-test \
        -p 8091:80 \
        -v $(pwd)/log:/tmp/xdebug \
        creativeprojects/webgrind

export:
    #!/bin/zsh
    docker save nnurphy/phpf:7.2 nnurphy/phpf:5.6 \
        | zstd -c -18 -T0 \
        | tee >(ssh eng-37  'zstd -d | docker load') \
        | tee >(ssh eng     'zstd -d | docker load') \
        | tee >(ssh eng-dev 'zstd -d | docker load') \
        | tee >(ssh xmh     'zstd -d | docker load') \
        | tee >(ssh eainger 'zstd -d | docker load') \
        > ~/pub/Platform/php/phpf.tar.zst
