
hello:
    @echo hello

default:
    xsearch-dbup a.xlsx 2>/dev/null |tee a.txt |wc

help:
    @ echo 'export LS_COLORS="$(vivid generate molokai)"'

xsearch-dbup FILE:
    #xf-parse -f code-name {{FILE}}
    xf-parse -f code-name --host tyun {{FILE}}
    ssh tyun 'psql myt1 -c "SELECT COUNT(*) FROM warelis"'

update_code-name +FILES:
    update_code-name {{FILES}} >code-name.$(date +%m%d) 2>/tmp/update_code-name.log
    ln -sf code-name.$(date +%m%d) code-name
    bat code-name
    @rg '^Updated' /tmp/update_code-name.log || true

stone-story:
    curlftpfs 192.168.9.55 ~/mnt/Music
    ln -sf ~/mnt/Music/foobar2000\ Music\ Folder/stone-story .

