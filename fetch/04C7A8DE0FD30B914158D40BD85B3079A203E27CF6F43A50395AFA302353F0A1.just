build:
    docker build . -t resty --progress=plain

assets:
    wget -c https://raw.githubusercontent.com/openresty/docker-openresty/master/nginx.conf
    wget -c https://raw.githubusercontent.com/openresty/docker-openresty/master/nginx.vh.default.conf