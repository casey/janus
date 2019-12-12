all:
  @echo "Run nix-build"

watch-exec FILE:
  #!/bin/bash
  dir=`dirname {{ FILE }}`
  watchexec --clear --restart --exts cr "crystal run {{ FILE }}"
