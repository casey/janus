plot:
  stack runhaskell plotting.hs
  rsvg-convert -f pdf -o plot.pdf plot.svg

watch: plot
  okular plot.pdf &
  fd | entr -rc just plot
