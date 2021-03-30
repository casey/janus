_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

# ~/Downloads
du-HOME-Downloads:
    du -d 1 -k ~/Downloads | sort -n

# ~/.Trash
du-HOME-Trash:
    du -d 1 -k ~/.Trash | sort -n

# /Applications
du-Applications:
    du -d 1 -k /Applications | sort -n

# /usr/local/Cellar
du-usr-local-Cellar:
    du -d 1 -k /usr/local/Cellar | sort -n

# /usr/local/Caskroom
du-usr-local-Caskroom:
    du -d 1 -k /usr/local/Caskroom | sort -n
