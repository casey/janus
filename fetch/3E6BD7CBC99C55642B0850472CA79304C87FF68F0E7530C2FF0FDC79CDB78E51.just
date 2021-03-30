#!/usr/bin/env just --justfile

_:
    echo "${KeePassXC_frp}"
    secrets=($(cmdshelf run KeePassXC/show-password --set database_name "${KeePassXC_frp}" entry frps_token frps_dashboard frpc_admin)) && \
    export TOKEN="${secrets[0]}" && \
    export FRPS_DASHBOARD_KEY="${secrets[1]}" && \
    export FRPC_ADMIN_KEY="${secrets[2]}" && \
    frpc
