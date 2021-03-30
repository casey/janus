set shell := ["powershell.exe", "-ExecutionPolicy", "Bypass", "-c"]

tarball:
    tar -czf oracle.tar.gz dist public package.json .htaccess
