watch:
    watchexec -w src -- wasm-pack build --dev -t web --out-name package --out-dir public/pkg

serve:
    microserver public

build-css:
    npm run build:dev

build-prod:
    npm run build:prod
    wasm-pack build --release -t web --out-name package --out-dir public/pkg

build-dev:
    npm run build:dev
    wasm-pack build --dev -t web --out-name package --out-dir public/pkg
