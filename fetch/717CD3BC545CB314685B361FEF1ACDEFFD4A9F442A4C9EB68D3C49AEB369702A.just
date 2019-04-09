testBuild = "build/rack.love"

run:
    love .

# run on your device
# put $DEVICE_DIR and $ADB_PATH to .env file
arun: pack
    $ADB_PATH push ./{{testBuild}} "$DEVICE_DIR"
    $ADB_PATH shell am start -S -n "org.love2d.android/.GameActivity" -d "file://$DEVICE_DIR"

pack: build
    mkdir -p build
    zip -r {{testBuild}} * -x "*.git*" "*.fnl" "Justfile" "README.md" "build"
    du -hs {{testBuild}}

build:
    tup
