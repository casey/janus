# build release binary
build: resources
  go build -ldflags "-s -w" -o TodoServe ./

# dovnload dependencies
dep:
  go get github.com/gin-gonic/gin
  go get github.com/satori/go.uuid
  go get gopkg.in/russross/blackfriday.v2
  go get golang.org/x/text/unicode/norm
  go get golang.org/x/text/transform
  go get github.com/gin-contrib/sessions

# run testing
test: resources
  go test

# make README.md
# README.md: README.mds
#  mdpreproc < README.mds > README.md

# copy release binary to ~/bin directory
install: build test 
  # README.md
  wget -O - 'http://127.0.0.1:39095/quit' || echo ok
  sleep 5s
  cp -v TodoServe ~/bin/
  ~/bin/TodoServe -editor gvim -notepath /home/martin/vimwiki/ukoly &
  disown

# clean all temporary files
clean:
  rm -f bindata.go TodoServe

# build embeded resources
resources: clean
  go-bindata resources

#release: install
#  git tag $(TAG)
#  git push origin --tags
#  cp -v -v BioRythm ~/Dropbox/Martin/Projects/BioRythm/BioRythm.Linux.x64.$(TAG)

# upx

