build version path="src/index.vue":
    npx vue-cli-service build --target lib --formats umd --formats umd-min --no-clean --dest dist --name "${PKG_NAME}.{{version}}" {{path}}

publish dist:
    scp "dist/${PKG_NAME}.umd.min.js" \
        "dist/${PKG_NAME}.umd.min.js.map" \
        {{dist}}/${PKG_NAME}

image-addon:
    docker build -t nnurphy/vuep:addon -f Dockerfile-addon .
image:
    docker build -t nnurphy/vuep -f Dockerfile .