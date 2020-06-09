version := `git describe --always --long --dirty 2> /dev/null|| echo "${USER}-dev"`
version_flag := "-X " + "main.version=" + version

# Compile dev binary for current toolchain
build-dev:
  go build -i -v -trimpath -ldflags="{{version_flag}}"

# Compile release binary for current toolchain
build-release:
  go build -i -v -trimpath -ldflags="{{version_flag}} -s -w"

# Installs release binary for current toolchain to $GOPATH/bin
install:
  go install -i -trimpath -ldflags="{{version_flag}} -s -w"
