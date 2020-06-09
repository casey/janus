all:
  @echo "Run nix-build"

watch-exec FILE:
  #!/bin/bash
  watchexec --clear --restart --exts cr "crystal run {{ FILE }}"
