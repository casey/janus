
metals_version := "0.7.6"
scripts_path := "${HOME}/scripts"


# set softlinks for all dotfiles
@setup:
    python3 set_softlinks.py

# install metals-vim
@metals:
    curl -L -o coursier https://git.io/coursier
    chmod +x coursier
    ./coursier bootstrap \
      --java-opt -Xss4m \
      --java-opt -Xms100m \
      --java-opt -Dmetals.client=coc.nvim \
      org.scalameta:metals_2.12:{{ metals_version }} \
      -r bintray:scalacenter/releases \
      -r sonatype:snapshots \
      -o {{ scripts_path }}/metals-vim -f
    rm coursier

all: setup metals
