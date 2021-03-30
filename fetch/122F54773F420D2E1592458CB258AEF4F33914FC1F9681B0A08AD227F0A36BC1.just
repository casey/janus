#!/usr/bin/env just --justfile

_:
    echo "${KeePassXC_frp}"
    secrets="$(cmdshelf run KeePassXC/show-password --set database_name "${KeePassXC_frp}" entry frps_token)" && \
    export TOKEN="${secrets}" && \
    frpc
