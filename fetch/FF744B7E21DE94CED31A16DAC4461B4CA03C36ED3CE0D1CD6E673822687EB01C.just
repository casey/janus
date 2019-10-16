@_default:
  just --list

build: assets gfm

assets:
  mkdir -p assets
  plantuml -tpng networkd-broker-seq.plantuml -o assets/ 2>/dev/null

# Export to GitHub Flavored Markdown
gfm:
  pandoc --from=gfm --to=gfm README-src.md --output=../README.md
