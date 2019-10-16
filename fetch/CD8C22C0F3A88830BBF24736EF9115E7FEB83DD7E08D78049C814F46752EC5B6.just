build:
    rsync -ahx favicon/output/ .
    cp favicon/src/manifest.json .
    parcel build --public-url /tool/ft4ed --no-source-maps index.pug
    rsync -ahxv favicon/output/ dist

