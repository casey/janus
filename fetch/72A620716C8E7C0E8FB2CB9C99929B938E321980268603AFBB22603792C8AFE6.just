_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

code:
    code "$(realpath ./scala.code-workspace)"

polynote:
    polynote --config "$(realpath ./polynote/config.yml)"

polynote-install:
    cd /usr/local/opt/polynote/libexec && \
    pip3 install -r ./requirements.txt