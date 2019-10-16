build:
    docker build . -t nnurphy/phpf:7.2 --progress=plain \
        --build-arg s6url=http://172.178.1.204:2015/s6-overlay-amd64.tar.gz \
        --build-arg php_url=http://172.178.1.204:2015/php-7.2.22.tar.xz

info:
    docker run --rm \
        --name=test \
        -p 8088:80 \
        -p 9002:9002 \
        -e XDEBUG_CONFIG='remote_port=9002' \
        -v vscode-server-php:/root/.vscode-server \
        -v $(pwd)/index.php:/srv/index.php \
        phpf:7.2

test:
    docker run --rm \
        --name=test \
        -p 8088:80 \
        -v vscode-server-php:/root/.vscode-server \
        -v $(pwd)/../mantis-php/mantis:/srv \
        phpf:7.2

debug:
    docker run --rm -it \
        --network=container:test \
        --pid=container:test \
        deb

start:
    curl -b "XDEBUG_SESSION=sublime.xdebug" http://localhost:8088/