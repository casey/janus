build:
    pandoc --self-contained -s -t revealjs index.md -o ./docs/index.html

watch:
    watchexec -e md "just build && echo 'ding'"
