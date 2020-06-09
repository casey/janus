build:
    docker-compose build

run:
    docker-compose up --build --abort-on-container-exit

shell: build
    docker run --name resty -p 80:80 -p 443:443 --rm -it resty /bin/bash

watch:
    watchexec -w frontend -w nginx -w service -c -r just run

vue-shell:
    docker build -t vuecli -f vue.dockerfile .
    docker run --rm -it \
        -v $PWD:/work \
        -u 1000:1000 \
        --net host \
        -w /work \
        --entrypoint '' \
        vuecli sh

vue:
    docker run --rm -it \
        -u 1000:1000 \
        -v $PWD:/work \
        --net host \
        -w /work/frontend --entrypoint '' \
        node:lts-alpine npm run serve
