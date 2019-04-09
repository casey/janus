format:
    find . -type f -name '*.mint' -exec mint format {} \;

deploy:
    mint build
    git checkout deploy
    git reset --hard
    cp -rlf dist/* ./
    rm -rf dist
    git add .
    git commit -m "Deploy `date "+%Y-%m-%d %H:%M:%S"`"
    git checkout master
