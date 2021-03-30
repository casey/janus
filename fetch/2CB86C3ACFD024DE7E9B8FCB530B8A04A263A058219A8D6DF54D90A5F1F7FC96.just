set shell := ["powershell.exe", "-ExecutionPolicy", "Bypass", "-c"]

ctoc:
    rm public/*.*
    rm -Force oracle.tar.gz
    cp -Force ../stock_facade/dist/release/*.* public
    just tarball

tarball:
    tar -czf oracle.tar.gz dist public package.json .htaccess

transfer:
    scp oracle.tar.gz server202:~/webapps