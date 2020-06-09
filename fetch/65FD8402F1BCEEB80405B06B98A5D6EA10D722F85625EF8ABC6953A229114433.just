prep:
  find . -name justfile -mindepth 2 -exec just -f {} prep \;
