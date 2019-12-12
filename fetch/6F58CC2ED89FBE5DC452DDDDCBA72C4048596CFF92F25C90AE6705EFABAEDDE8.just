all: keys

keys:
    T=$(mktemp) && \
    <nodesource.asc gpg       --no-default-keyring --keyring "$T" --import; \
    <postgresql.asc gpg       --no-default-keyring --keyring "$T" --import; \
    <yarn.asc       gpg       --no-default-keyring --keyring "$T" --import; \
    gpg --output mastodon.gpg --no-default-keyring --keyring "$T" --export; \
    rm "$T"
