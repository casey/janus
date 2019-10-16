img tag="latest":
    #!/bin/bash
    tag={{tag}}
    echo "tag=$tag from-tag=${tag/#latest/runtime}"
    docker build . -t nnurphy/dotnetcore:${tag} --progress=plain \
        --build-arg s6url=http://172.178.1.204:2015/s6-overlay-amd64.tar.gz \
        --build-arg tag=${tag/#latest/runtime}