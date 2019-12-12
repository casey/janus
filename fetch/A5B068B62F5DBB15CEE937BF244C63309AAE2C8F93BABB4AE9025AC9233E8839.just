build:
    docker build . -t nnurphy/vscw \
        --build-arg vscode_url=http://172.178.1.204:2015/vsc/1.40.0.tar.gz

run:
    docker run --name vscw \
        --rm \
        -it \
        -p 8080:8080 \
        nnurphy/vscw bash