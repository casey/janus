@_default:
  just --list

bumpversion version:
  @just bump-cargo {{version}}
  @just bump-pkgbuild {{version}}

bump-cargo version:
  @cargo bump {{version}}

bump-pkgbuild version:
  @sed -i -e "s/pkgver=.*/pkgver={{version}}/g" -e "s/pkgrel=.*/pkgrel=1/g"  PKGBUILD.local
  @sed -i -e "s/pkgver=.*/pkgver={{version}}/g" -e "s/pkgrel=.*/pkgrel=1/g"  PKGBUILD.aur
