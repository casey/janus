# purge, purify, and uncss on html file
css target:
    @purgecss --css css/main.css --content {{target}} -o purged
    @purifycss css/main.css {{target}} -o purify/main.css
    @uncss {{target}} > uncss/main.css
    @echo "Original: "$(du -h css/main.css)
    @echo "Purged:   "$(du -h purged/main.css)
    @echo "Purify:   "$(du -h purify/main.css)
    @echo "Uncss:    "$(du -h uncss/main.css)
    @cp purged/main.css purged/$(dirname {{target}}).css
    @cp purify/main.css purify/$(dirname {{target}}).css
    @cp uncss/main.css uncss/$(dirname {{target}}).css

# get sizes of purged css, imgs, fonts, & js
size:
    @echo Purged
    @fd . purged/ -e css -x du -h
    @echo
    @fd . img/ -x du -h
    @echo
    @fd . fonts/ -x du -h
    @echo
    @fd . js/ -x du -h

# Compress content w. gzip & brotli
compress:
    @echo "Removing old Gzip/Brotli files"
    @fd . dist -e gz -e br -x rm
    @echo "Gzip compressing all web files"
    @fd . dist -e html -e css -e js -x gzip -k -9 
    @echo "Brotli compressing all web files"
    @fd . dist -e html -e css -e js -x brotli -q 11

# Serve webpages
serve target: 
    simple-http-server -i -- {{target}}

# Build Hugo to src and minify into dist
hugo:
    #!/bin/bash
    pushd news > /dev/null
    echo "Building hugo into src"
    hugo -d ../src/news > /dev/null
    echo "Building hugo & minifying into dist"
    hugo --minify -d ../dist/news > /dev/null
    popd > /dev/null

# Build hugo, compress dist, and sync with Server
send: hugo compress sync
