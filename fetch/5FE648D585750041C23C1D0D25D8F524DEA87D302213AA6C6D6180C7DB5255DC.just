export name := "procs"
export version := "0.10.7"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "procs-v"+version+"-x86_64-lnx.zip"
url := "https://github.com/dalance/procs/releases/download/v"+version+"/"+ar

get_release_assets:
  [ ! -f "{{ar}}" ] && wget {{url}} || true
  [ ! -d "assets" ] && mkdir "assets" || true
  rm assets/* || true
  unzip -j -d assets "{{ar}}"

clean:
  rm -rf "{{ar}}" assets

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
