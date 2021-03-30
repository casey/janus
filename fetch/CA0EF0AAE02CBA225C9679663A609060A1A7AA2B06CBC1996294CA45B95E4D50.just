export name := "navi"
export version := "2.14.0"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "navi-v"+version+"-x86_64-unknown-linux-musl.tar.gz"
url := "https://github.com/denisidoro/navi/releases/download/v"+version+"/"+ar

get_release_assets:
  [ ! -f "{{ar}}" ] && wget {{url}} || true
  [ ! -d "assets" ] && mkdir "assets" || true
  rm assets/* || true
  tar xzf "{{ar}}" -C assets
  wget --directory-prefix=assets https://github.com/denisidoro/navi/raw/master/README.md

clean:
  rm -rf "{{ar}}" assets

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
