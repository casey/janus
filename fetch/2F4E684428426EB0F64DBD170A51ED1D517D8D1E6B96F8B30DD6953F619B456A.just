make-flag:
    img2txt --width=100 -f html images/1000px-Flag_of_Washington.svg.png > images/1000px-Flag_of_Washington-100w.html
make-cga:
    convert images/1000px-Flag_of_Washington.svg.png -colors 4 -depth 4 -resize 320x200 art_cga_320_200/flag.WA.png
