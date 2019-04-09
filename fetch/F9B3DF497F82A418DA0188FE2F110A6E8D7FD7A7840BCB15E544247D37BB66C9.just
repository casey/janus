test DIRECTORY:
  nim c --cc:clang -r {{DIRECTORY}}/*test.nim

clean:
  rm -rf **/*.exe **/nimcache

fetch:
  exercism fetch nim

submit +FILES:
  exercism submit {{FILES}} 