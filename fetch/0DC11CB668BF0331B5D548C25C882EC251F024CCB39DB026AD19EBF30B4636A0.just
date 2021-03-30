build:
    cargo b --release

set_cap:
    doas setcap cap_net_admin=eip /home/m/gits/trustut/target/release/trustut

ips:
    ip addr

set_ip:
    doas ip addr add 192.168.0.1/24 dev tun0

run:
    /home/m/gits/trustut/target/release/trustut

set_link:
    doas ip link set up dev tun0

make:
    just build
    just set_cap
    just run
    just set_ip
    just set_link

