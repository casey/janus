cname 		= "moh.page"
rep 		= "moh.page"


deploy:
    cp -rf ./public ~/ws/.term/public
    cp ~/ws/.conf/fr/just/dep ~/ws/.term/public/
    mv ~/ws/.term/public/dep ~/ws/.term/public/justfile
    echo {{cname}} >> ~/ws/.term/public/CNAME
    rm -rf ./public
    (cd ~/ws/.term/public && just deploy {{rep}})
    rm -rf ~/ws/.term/public
