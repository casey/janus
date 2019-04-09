# build the project
build:
  { mkdir -p build; cd build; cmake ..; make; }

# run leveldb server
server: build
  ./build/leveldb_server

# run leveldb client
client: build
  ./build/leveldb_client

# setup the environment
setup_mac:
  brew install glog
  brew install gflags
  brew install folly
  brew install leveldb
  brew install yschimke/tap/rsocket-cli

# test after server started
cli_test:
  rsocket-cli --request -m "get nick" -i "" tcp://localhost:42252

# setup on Ubuntu
setup_ubuntu:
  sudo apt-get install g++ cmake libboost-all-dev libevent-dev libdouble-conversion-dev libgoogle-glog-dev libgflags-dev libiberty-dev libaio-dev libbz2-dev liblz4-dev libzstd-dev liblzma-dev libsnappy-dev make zlib1g-dev binutils-dev libjemalloc-dev libssl-dev pkg-config libunwind8-dev libelf-dev libdwarf-dev libsqlite3-dev google-perftools doxygen libtcmalloc-minimal4

# setup on CentOS
setup_centos
  sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum install http://repository.it4i.cz/mirrors/repoforge/redhat/el7/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
  sudo yum group install "Development Tools"
  sudo yum install centos-release-scl
  sudo yum install devtoolset-7-gcc*
  scl enable devtoolset-7 bash
  sudo yum install boost-devel
  sudo yum install gflags-devel glog-devel double-conversion-devel jemalloc-devel libunwind-devel libevent-devel openssl-devel libgcrypt-devel bzip2 bzip2-devel  lz4-devel  zstd  snappy-devel binutils-devel libaio-devel xz-devel libatomic libzstd-devel libdwarf-devel sqlite-devel