img:
    docker run \
        -p 1080:1080 \
        -d --restart=always \
        --name gs \
        nashv1/gs \
        -cu "ss://${method}:${password}@${host}"