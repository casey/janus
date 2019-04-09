TAG = `date +%Y%m%d`
GITHUB_TOKEN = env_var("GITHUB_TOKEN")

# build production program
build: dep
  go build -ldflags "-s -w" -o bin/dict

# build windows version
win: build
  GOOS=windows go build -ldflags "-s -w" -o bin/dict.exe

# rebuild docs
docs: install
  gpp -x README.src.md > README.md
  git add README.md
  git commit -a -m 'rebuild docs'
  git push origin

# dovnload dependencies
dep:
  go get github.com/spf13/cobra/cobra
  go get github.com/mattn/go-sqlite3
  go get github.com/fatih/color
  go get github.com/inconshreveable/mousetrap

#  go get github.com/gin-gonic/gin
#  go get github.com/satori/go.uuid
#  go get gopkg.in/russross/blackfriday.v2
#  go get golang.org/x/text/unicode/norm
#  go get golang.org/x/text/transform
#  go get github.com/gin-contrib/sessions

# run testing
# test: resources
#  go test

# copy release binary to ~/bin directory
install: build
  cp -v bin/dict ~/bin/

# clean all temporary files
clean:
  rm -f bin/*
#  rm -f bindata.go TodoServe

# build embeded resources
# resources: clean
#  go-bindata resources

# make release and publish them
release: install docs win
  git tag {{TAG}}
  git push origin --tags
  gothub release --user martinlebeda --repo mldict --tag {{TAG}}
  gothub upload --user martinlebeda --repo mldict --tag {{TAG}} --name "dict.linux.x64" --file bin/dict
  gothub upload --user martinlebeda --repo mldict --tag {{TAG}} --name "dict.windows.x64.exe" --file bin/dict.exe

  # TODO - add some way to release build
  #  --name "the wolf of source street" --description "Not a movie, contrary to popular opinion. Still, my first release!" --pre-release



# upx

