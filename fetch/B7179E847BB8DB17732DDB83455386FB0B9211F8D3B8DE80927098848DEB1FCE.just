build:
    docker build . -t phpf:7.2 --progress=plain

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