@_all:
    just --list

KAK_CONFIG:="${HOME}/.config/kak/plugins/kakoune-pick"

@install:
    [ -d "{{ KAK_CONFIG }}" ] || ( echo {{ KAK_CONFIG }} not exists; exit 1 )
    rsync -avu --delete "{{ justfile_directory() }}/" "{{ KAK_CONFIG }}"  
