run:
    @crystal src/passgen.cr

install:
    shards build --production
    cp bin/passgen ~/.local/bin/

uninstall:
    rm ~/.local/bin/passgen