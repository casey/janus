prepare:
        rm -rf deployment
        mkdir deployment
        mkdir deployment/cljs-out
        cp resources/public/index.html deployment
        cp resources/public/cljs-out/dev-main.js deployment/cljs-out/