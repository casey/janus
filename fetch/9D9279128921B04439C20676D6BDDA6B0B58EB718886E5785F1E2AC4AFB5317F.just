# build the project
build:
  { mkdir -p build; cd build; cmake ..; make; }

# run leveldb server
server: build
  ./build/leveldb_server

# run leveldb client
client: build
  ./build/leveldb_client

# test after server started
cli_test:
  rsocket-cli --request -m "get nick" -i "" tcp://localhost:42252sudo yum install gflags-devel glog-devel double-conversion-devel jemalloc-devel libunwind-devel libevent-devel openssl-devel libgcrypt-devel bzip2 bzip2-devel  lz4-devel  zstd  snappy-devel binutils-devel libaio-devel xz-devel libatomic libzstd-devel libdwarf-devel sqlite-devel

# build leveldb
build_leveldb:
   #!/usr/bin/env sh
   cd ~/
   wget -qO- -O tmp.zip https://github.com/google/leveldb/archive/master.zip && unzip tmp.zip && rm tmp.zip
   cd ~/leveldb-master
   mkdir _build
   cd _build
   cmake -DCMAKE_BUILD_TYPE=Release ../
   make
   sudo make install

# build Folly
build_folly:
   #!/usr/bin/env sh
   cd ~/
   wget -qO- -O tmp.zip https://github.com/facebook/folly/archive/master.zip && unzip tmp.zip && rm tmp.zip
   cd ~/folly-master
   mkdir _build
   cd _build
   cmake -DCMAKE_BUILD_TYPE=Release ../
   make
   sudo make install

# build rsocket cpp
build_rsocket:
   #!/usr/bin/env sh
   cd ~/
   wget -qO- -O tmp.zip https://github.com/rsocket/rsocket-cpp/archive/master.zip && unzip tmp.zip && rm tmp.zip
   cd ~/rsocket-cpp-master
   mkdir _build
   cd _build
   cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_BENCHMARKS=OFF ..
   make
   sudo make install