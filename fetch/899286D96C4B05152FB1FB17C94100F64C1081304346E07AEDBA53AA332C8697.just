TAG = `date +%Y%m%d`

# build production program
build: dep
  go build -ldflags "-s -w" -o bin/git-find

# build windows version
win: build
  GOOS=windows go build -ldflags "-s -w" -o bin/git-find.exe

# rebuild docs
docs: install
  gpp -x README.src.md > README.md
  git add README.md
  git commit -a -m 'rebuild docs'
  git push origin

# download dependencies
dep:
  go get github.com/spf13/cobra/cobra
  go get github.com/mattn/go-sqlite3
  go get github.com/fatih/color
  go get github.com/inconshreveable/mousetrap # for windows compilation
  go get gopkg.in/pipe.v2

# run testing
# test: resources
#  go test

# copy release binary to ~/bin directory
install: build
  cp -v bin/git-find ~/bin/

# clean all temporary files
clean:
  rm -f bin/*
#  rm -f bindata.go TodoServe

# build embeded resources
# resources: clean
#  go-bindata resources

# make release and publish them
release: install docs win
  # for release must be set GITHUB_TOKEN env variable
  git tag {{TAG}}
  git push origin --tags
  gothub release --user martinlebeda --repo git-find --tag {{TAG}}
  gothub upload --user martinlebeda --repo git-find --tag {{TAG}} --name "git-find.linux.x64" --file bin/git-find
  gothub upload --user martinlebeda --repo git-find --tag {{TAG}} --name "git-find.windows.x64.exe" --file bin/git-find.exe

  # TODO - add some way to release build
  #  --name "the wolf of source street" --description "Not a movie, contrary to popular opinion. Still, my first release!" --pre-release

# upx

