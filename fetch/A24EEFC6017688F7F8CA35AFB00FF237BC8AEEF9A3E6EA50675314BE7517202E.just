_svg2png name size:
  inkscape -z -e {{name}}_{{size}}.png -w {{size}} {{name}}.svg
  inkscape -z -e {{name}}_{{size}}@2x.png -w `expr {{size}} \* 2` {{name}}.svg
  inkscape -z -e {{name}}_{{size}}@3x.png -w `expr {{size}} \* 3` {{name}}.svg

_convert_logo_geek-black-and-white:
  @just _svg2png logo/geek-black-and-white 16
  @just _svg2png logo/geek-black-and-white 32
  @just _svg2png logo/geek-black-and-white 64
  @just _svg2png logo/geek-black-and-white 128
  @just _svg2png logo/geek-black-and-white 256
  @just _svg2png logo/geek-black-and-white 512

_convert_logo_geek-yellow:
  @just _svg2png logo/geek-yellow 16
  @just _svg2png logo/geek-yellow 32
  @just _svg2png logo/geek-yellow 64
  @just _svg2png logo/geek-yellow 128
  @just _svg2png logo/geek-yellow 256
  @just _svg2png logo/geek-yellow 512

_convert_icon_icon:
  @just _svg2png icon/icon 16
  @just _svg2png icon/icon 32
  @just _svg2png icon/icon 64
  @just _svg2png icon/icon 128
  @just _svg2png icon/icon 256
  @just _svg2png icon/icon 512

convert:
  @just _convert_logo_geek-black-and-white
  @just _convert_logo_geek-yellow
  @just _convert_icon_icon
  @min img
