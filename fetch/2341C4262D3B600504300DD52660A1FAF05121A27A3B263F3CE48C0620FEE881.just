export name := "fzf"
export version := "0.25.0"
set shell := ["bash", "-c"]

debdir := "../../deb"
debfile := debdir+"/"+name+"-"+version+"_amd64.deb"
ar := "fzf-"+version+"-linux_amd64.tar.gz"
url := "https://github.com/junegunn/fzf/releases/download/"+version+"/"+ar

get_release_assets:
  [ ! -f "{{ar}}" ] && wget {{url}} || true
  [ ! -d "assets" ] && mkdir "assets" || true
  rm assets/* || true
  # Le paquet ne contient que fzf
  tar xzf "{{ar}}" -C assets
  wget --directory-prefix=assets https://github.com/junegunn/fzf/raw/master/man/man1/fzf.1 https://github.com/junegunn/fzf/raw/master/man/man1/fzf-tmux.1
  wget --directory-prefix=assets https://github.com/junegunn/fzf/raw/master/bin/fzf-tmux
  chmod 755 assets/fzf{,-tmux}
  
clean:
  rm -rf "{{ar}}" assets

deb:
  nfpm pkg -f <(envsubst '${name} ${version}' < nfpm.yaml) -t "{{debfile}}"

release: get_release_assets deb clean

install:
  #!/usr/bin/env bash
  [[ ! -f "{{debfile}}" ]] && just install
  sudo dpkg -i {{debfile}}
