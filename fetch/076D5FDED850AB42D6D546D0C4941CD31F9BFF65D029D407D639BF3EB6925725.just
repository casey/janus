# build with cmake
build:
  { mkdir -p build; cd build; cmake ..; make; }

# use brew to install necessary formulas
setup:
  brew install openssl boost libxml2 nghttp2

# cli build with clang++
cli_build:
  clang++ -std=c++11 -I/usr/local/opt/openssl/include   -L/usr/local/opt/openssl/lib -L/usr/local/opt/boost/lib/  -lssl -lcrypto -lpthread  -lboost_system -lnghttp2 -lnghttp2_asio main.cpp

# testing
testing:
  curl --http2 --http2-prior-knowledge http://localhost:3000/