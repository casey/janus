@_default:
  just --list

build: gfm

# Export to GitHub Flavored Markdown
gfm:
  pandoc --from=gfm --to=gfm README-src.md --output=../README.md
