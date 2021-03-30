deb:
  #!/usr/bin/env bash
  get_nfpm(){
    local prop="$1"
    local re=$(printf '^%s: "([^"]+)"' "${prop}")
    rg -o "${re}" -r'$1' nfpm.yaml
  }
  version=$(get_nfpm version)
  name=$(get_nfpm name)
  nfpm pkg -f nfpm.yaml -t ../${name}-${version}_amd64.deb

readme:
  wget https://github.com/lotabout/skim/raw/master/README.md