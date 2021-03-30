_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

list:
    mint list

which-mint:
    mint which mint

run-mint:
    mint run mint

install-mint:
    mint install yonaskolb/mint

help:
    mint help

version:
    mint version

bootstrap:
    mint bootstrap --link

open-hello-world:
    open -a Xcode ./Mint-Hello-World

install-hello-world-by-url:
    mint install https://github.com/huzhenghui/Mint-Hello-World

install-hello-world:
    mint install huzhenghui/Mint-Hello-World

mint-which-hello-world-by-url:
    mint which https://github.com/huzhenghui/Mint-Hello-World

mint-which-hello-world:
    mint which Mint-Hello-World

mint-run-hello-world-by-url:
    mint run https://github.com/huzhenghui/Mint-Hello-World argument1 argument2 argument3

mint-run-hello-world-by-url-postfix-executable:
    mint run https://github.com/huzhenghui/Mint-Hello-World Mint-Hello-World argument1 argument2 argument3

mint-run-hello-world-by-url-prefix-executable:
    mint run --executable Mint-Hello-World https://github.com/huzhenghui/Mint-Hello-World argument1 argument2 argument3

mint-run-hello-world:
    mint run Mint-Hello-World argument1 argument2 argument3

mint-run-hello-world-postfix-executable:
    mint run Mint-Hello-World Mint-Hello-World argument1 argument2 argument3

mint-run-hello-world-prefix-executable:
    mint run --executable Mint-Hello-World Mint-Hello-World argument1 argument2 argument3

which-hello-world:
    which Mint-Hello-World

execute-mint-which-hello-world-by-url:
    $(mint which https://github.com/huzhenghui/Mint-Hello-World | tail -n 1) argument1 argument2 argument3

execute-mint-which-hello-world:
    $(mint which Mint-Hello-World | tail -n 1) argument1 argument2 argument3

execute-which-hello-world:
    $(which Mint-Hello-World) argument1 argument2 argument3

uninstall-hello-world-by-url:
    mint uninstall https://github.com/huzhenghui/Mint-Hello-World

uninstall-hello-world:
    mint uninstall Mint-Hello-World
