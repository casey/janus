dev:
  hugo server

build:
  hugo -b http://rsocketbyexample.info -t hugo-notepadium

deploy_oss: build
  ossutil cp -r docs oss://rsocketbyexampleus --update

deploy_server: build
  scp -r docs/* root@rsocketbyexample.com:/home/virtual_hosts/rsocketbyexample.com

deploy_github:
  (cd docs; git add -A; git commit -m "Update content"; git push -u origin master)
