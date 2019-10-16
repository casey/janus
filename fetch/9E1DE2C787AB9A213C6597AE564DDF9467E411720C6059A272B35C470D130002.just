@_default:
  just --list

release version:
  @cargo bump {{version}}
  @cargo check
  @just _bump-pkgbuild {{version}}
  @git add .
  @git ci -m "chore(release): {{version}}"
  @git tag -s -a {{version}} -m "version {{version}}"

_bump-pkgbuild version:
  @sed -i -e "s/pkgver=.*/pkgver={{version}}/g" -e "s/pkgrel=.*/pkgrel=1/g"  PKGBUILD.local
  @sed -i -e "s/pkgver=.*/pkgver={{version}}/g" -e "s/pkgrel=.*/pkgrel=1/g"  PKGBUILD.aur
