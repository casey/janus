inc:
    docker build . -t nnurphy/context:inc -f Dockerfile-inc

build:
    docker build . -t nnurphy/context

test: inc
    docker run --rm \
        -it \
        -e OSFONTDIR="/usr/share/fonts/{adobe,winfonts}" \
        -v $PWD/test:/root \
        --name context-mkiv \
        nnurphy/context:inc \
        bash