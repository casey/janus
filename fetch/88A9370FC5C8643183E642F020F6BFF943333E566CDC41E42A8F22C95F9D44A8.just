build:
    buildah bud --pull-never -f Dockerfile -t docker-daemon:nnurphy/neovim:latest .

build-base:
    buildah bud --pull-never -f Dockerfile-base -t docker-daemon:nnurphy/neovim:base .
