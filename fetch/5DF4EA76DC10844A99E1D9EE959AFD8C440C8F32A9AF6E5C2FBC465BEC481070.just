export name := "slap"
export version := "1.3.1"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "slap-"+version+"-x86_64-unknown-linux-musl.tar.gz"
url := "https://github.com/agnipau/slap/releases/download/"+version+"/"+ar

get_release_assets:
  [ ! -f "{{ar}}" ] && wget {{url}} || true
  [ ! -d "assets" ] && mkdir "assets" || true
  rm assets/* || true
  tar xzf "{{ar}}" -C assets --strip-components=1

clean:
  rm -rf "{{ar}}" assets

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
