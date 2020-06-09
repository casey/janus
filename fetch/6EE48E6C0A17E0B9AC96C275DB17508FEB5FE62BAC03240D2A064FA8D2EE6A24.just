setup:
    mkdir -p tmp/{root,mnt}

runsrv:
    cargo run -- tmp/root tmp/sock
    rm tmp/sock

mount:
    ~/plan9port/bin/9fuse tmp/sock tmp/mnt
