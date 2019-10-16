build:
  docker build -t godev .

run: build
   docker run -it \
   -v `pwd`/volume/.emacs.d:/home/emacs/.emacs.d \
   -v `pwd`/volume/proj:/home/me/proj/work \
   godev
