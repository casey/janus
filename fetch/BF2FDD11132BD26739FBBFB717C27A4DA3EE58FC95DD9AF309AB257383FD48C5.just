styles_root := "web/styles"
scripts_root := "web/frontend/scripts"
web_root := "web/webroot"
scratch_root := "scratch"
appserver_root := "web/backend"
dist_root := "dist"
static_server_port := "8001"

# just autoloads .env when ran
app_username := `echo $APP_USERNAME`


@_make_tmp_dirs:
    mkdir -p {dist,scratch}

reload-appserver:
    #!/bin/sh
    mkdir -p dist
    PID=$(pidof appserver)
    if test -n "$PID"
    then
        kill "$PID"
    fi

    ./{{dist_root}}/appserver

build-manifest: _make_tmp_dirs
    rsync {{web_root}}/manifest.json {{dist_root}}/manifest.json

build-pages: _make_tmp_dirs
    pug {{web_root}}/index.pug -o {{dist_root}}/

build-scripts: _make_tmp_dirs
    @# This hard-codes the username into the ES6 javascript.
    @# We use '{%' and '%}' for our custom replacement to avoid issues with
    @# just's variables
    sed -e 's/{%USERNAME%}/{{app_username}}/g' \
        {{scripts_root}}/hello.js > {{scratch_root}}/index.js

    @# It is then compiled to ES2015
    ./node_modules/@babel/cli/bin/babel.js --presets @babel/preset-env \
        {{scratch_root}}/index.js -o {{dist_root}}/index.js

build-styles: _make_tmp_dirs
    sass --sourcemap=none {{styles_root}}/index.scss {{dist_root}}/index.css

build-appserver target='debug' mode='': _make_tmp_dirs
    cd {{appserver_root}} && cargo build --target-dir ../../{{scratch_root}}/backend/ {{mode}}
    rsync {{scratch_root}}/backend/{{target}}/appserver {{dist_root}}/appserver

build-all:
    just build-pages
    just build-scripts
    just build-styles
    just build-appserver
    just build-manifest


watch-pages:
    #!/bin/sh
    while true; do
        ls {{web_root}}/*.pug | entr -d -p -s 'just build-pages \
            && just reload-browser firefox'
    done

watch-manifest:
    #!/bin/sh
    while true; do
        ls {{web_root}}/manifest.json | entr -d -p -s 'just build-manifest \
            && just reload-browser firefox'
    done

watch-scripts:
    #!/bin/sh
    while true; do
        ls {{scripts_root}}/* | entr -d -p -s 'just build-scripts \
            && just reload-browser firefox'
    done

watch-styles:
    #!/bin/sh
    while true; do
        ls {{styles_root}}/* | entr -d -p -s 'just build-styles \
            && just reload-browser firefox'
    done

watch-appserver:
    #!/bin/sh
    while true; do
        find -name '*.rs' -o -name '*.toml' | entr -d -s 'just build-appserver \
            && just reload-appserver \
            & just reload-browser firefox'
    done


run-dev-server:
    #!/bin/sh
    trap "exit" INT TERM ERR
    trap "kill 0" EXIT

    just build-all

    just watch-styles &
    just watch-pages &
    just watch-scripts &
    just watch-appserver &
    just watch-manifest &

    python -m http.server --directory {{dist_root}} {{static_server_port}} &

    wait
    

reload-browser name:
    #!/bin/sh 
    CURRENT_WINDOW=$(xdotool getactivewindow)

    xdotool search --all --onlyvisible --class {{name}} \
        windowfocus sleep 0.1 key --window %@ 'F5'

    xdotool windowfocus --sync ${CURRENT_WINDOW}
    xdotool windowactivate --sync ${CURRENT_WINDOW}
