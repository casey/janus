run:
    docker run \
        --name wg \
        -d --restart=always \
        --cap-add net_admin \
        --cap-add sys_module \
        -v /lib/modules:/lib/modules \
        -v $PWD/wg0.conf:/etc/wireguard/wg0.conf \
        -p 5555:5555/udp \
        nnurphy/wg


install-mod:
    docker run -it --rm \
        --cap-add sys_module \
        -v /lib/modules:/lib/modules \
        -v /usr/src:/usr/src \
        nnurphy/wg install-module

genkey:
    docker run -it --rm nnurphy/wg genkeys