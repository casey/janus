build:
  ninja -C build

clean:
  ninja -C build clean

watch:
  watchexec -c -w src "ninja -C build"
