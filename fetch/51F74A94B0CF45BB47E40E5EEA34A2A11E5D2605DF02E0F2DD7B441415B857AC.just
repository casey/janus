build:
    mkdir -p target
    nim c -d:release --opt:speed -o:target/sound-garden src/main.nim

watch:
    watchexec -e nim -- just build

pack: build
    strip target/sound-garden
    7z a target/sg.7z target/sound-garden

run +FLAGS='':
    rlwrap target/sound-garden {{FLAGS}}

tui +FLAGS='':
    target/sound-garden --tui {{FLAGS}}
