export name := "featmap"
export version := "2.0.1"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "featmap-"+version+"-linux-amd64"
url := "https://github.com/amborle/featmap/releases/download/v"+version+"/"+ar

get_release_assets:
  [ ! -f "{{ar}}" ] && wget {{url}} || true
  [ ! -d "assets" ] && mkdir "assets" || true
  rm assets/* || true
  mv "{{ar}}" assets/featmap
  chmod 755 assets/featmap
  wget --directory-prefix=assets https://github.com/amborle/featmap/raw/master/config/.env
  wget --directory-prefix=assets https://github.com/amborle/featmap/blob/master/config/conf.json

clean:
  rm -rf "{{ar}}" assets/featmap

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
