export name := "alacritty-themes"
export version := "2020.11.25"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "alacritty-v"+version+"-x86_64-lnx.zip"
url := "https://github.com/dalance/alacritty/releases/download/v"+version+"/"+ar


bootstrap:
  [ ! -d "assets" ] && mkdir "assets" || true
  git clone --depth=1 https://github.com/eendroroy/alacritty-theme assets/alacritty-theme

get_release_assets:
  #[ ! -f "{{ar}}" ] && wget {{url}} || true
  #[ ! -d "assets" ] && mkdir "assets" || true
  #rm assets/* || true
  #unzip -j -d assets "{{ar}}"
  convert /home/ngirard/sandboxes/rust/alacritty/extra/logo/alacritty-term.svg assets/alacritty.png

clean:
  rm -rf "{{ar}}" assets

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
