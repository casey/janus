_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

home:
    brew home swift-sh

shebang:
    #!/usr/bin/swift sh
    import PromiseKit // @mxcl ~> 6.5
    print(Promise.value("Hello World from swift-sh!"))

swift-sh-script:
    swift sh ./swift-sh-script.swift

scripty:
    chmod u+x ./swift-sh-script.swift
    ./swift-sh-script.swift
    chmod u-x ./swift-sh-script.swift

swift-sh-edit-script:
    echo 2020-9-12,失败
    swift sh edit ./swift-sh-script.swift

swift-sh-eject-script:
    # todo：尝试使用Xcode打开
    cp ./swift-sh-script.swift ./swift-sh-script-eject.swift
    swift sh eject ./swift-sh-script-eject.swift

clear:
    trash ./Swift-Sh-Script-Eject

open-by-xcode:
    open -a Xcode ./Swift-Sh-Script-Eject

build: swift-sh-eject-script
    cd ./Swift-Sh-Script-Eject && swift build

run:
    ./Swift-Sh-Script-Eject/.build/debug/Swift-Sh-Script-Eject