help:
  @just --list


ssh:
  @ssh jarppe-dev


build-cloud:
  ( cd cloud ; go build )


build-local:
  ( cd local ; go build )


build: build-cloud, build-local


#test: build
#  ./src/gobin -h jarppe-dev -s /Users/jarppe/swd/jarppe/gobin/example
