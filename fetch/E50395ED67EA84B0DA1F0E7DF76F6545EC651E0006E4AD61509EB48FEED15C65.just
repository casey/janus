build:
    pandoc --self-contained --slide-level=2 -s -t revealjs index.md -o ./docs/index.html && xdg-open ./docs/index.html

watch:
    watchexec -e md "just build && echo 'ding'"
