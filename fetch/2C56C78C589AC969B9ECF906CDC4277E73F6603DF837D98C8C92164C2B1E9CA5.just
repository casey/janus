init:
    docker run -it --rm --cap-add sys_module -v /lib/modules:/lib/modules wgc install-module

run config port="<externalport>:<dockerport>":
    docker run --cap-add net_admin --cap-add sys_module -v {{config}}:/etc/wireguard -p {{port}}/udp wgc

genkey:
    docker run -it --rm wgc genkeys

build:
    docker build . -t wgc

