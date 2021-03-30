test tag="latest":
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -p 8022:22 \
        -v $PWD:/app \
        -v vscode-server:/root/.vscode-server \
        -e WEB_ROOT=/app \
        -e WS_FIXED=1 \
        -v $PWD/id_ed25519.pub:/etc/authorized_keys/root \
        -v $PWD/services.d/watcher/run:/etc/services.d/watcher/run \
        nnurphy/or

#-v $PWD/nginx-site.conf:/etc/openresty/conf.d/default.conf \

or:
    docker run -d --name=or --restart=always \
        -e WEB_SERVERNAME=morphism.fun \
        -v $PWD/pub:/srv \
        -v $PWD/openresty/nginx.conf:/etc/openresty/nginx.conf \
        -v $PWD/openresty/conf.d:/etc/openresty/conf.d \
        -v $PWD/openresty/logs:/opt/openresty/nginx/logs \
        -v $PWD/openresty/auto-ssl.conf:/etc/openresty/auto_ssl.conf \
        -v $PWD/openresty/ssl:/etc/resty-auto-ssl \
        -p 80:80 \
        -p 443:443 \
        nnurphy/or

etcd port="2379":
    docker run -d --name=as-etcd --restart=always \
        -e ALLOW_NONE_AUTHENTICATION=yes \
        -p {{port}}:2379 \
        bitnami/etcd:3.4.15
as:
    docker run -d --name=as --restart=always \
        -p 9080:9080 \
        -p 9443:9443 \
        -p 9090:9090 \
        -e ETCD_HOST=172.17.0.1:12380 \
        -e APISIX_KEY=asdf \
        as

asd:
    docker run --rm \
        -v $PWD/apisix-dashboard.yaml:/usr/local/apisix-dashboard/conf/conf.yaml \
        -p 9000:9000 \
        apache/apisix-dashboard:2.4
