export name := "supertag"
export version := "0.1.2"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "supertag-x86_64.AppImage"
url := "https://github.com/amoffat/supertag/releases/latest/download/"+ar

get_release_assets:
  [ ! -f "{{ar}}" ] && wget {{url}} || true
  [ ! -d "assets" ] && mkdir "assets" || true
  rm assets/* || true
  #unzip -j -d assets "{{ar}}"
  curl -Ls "{{url}}" > assets/tag
  chmod 755 assets/tag 

clean:
  rm -rf "{{ar}}" assets

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
