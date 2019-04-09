stats:
    @ghstats vmchale fastcat | tail -n4 ; printf ''

check:
    git diff master origin/master

version:
    @grep -P -o '\d+\.\d+\.\d+' src/ac.dats

next:
    @export VERSION=$(cat src/ac.dats | grep -P -o '\d+\.\d+\.\d+' src/ac.dats | awk -F. '{$NF+=1; print $0}' | sed 's/ /\./g') && echo $VERSION && sed -i "s/[0-9]\+\.[0-9]\+\.[0-9]\+\+/$VERSION/" src/ac.dats
    @git commit -am "next"

name:
    github-release edit -s $(cat ~/.git-token) -u vmchale -r fastcat -n "$(madlang run ~/programming/madlang/releases/releases.mad)" -t "$(grep -P -o '\d+\.\d+\.\d+' src/ac.dats)"

release:
    git tag "$(grep -P -o '\d+\.\d+\.\d+' src/ac.dats)"
    git push origin --tags
    git tag -d "$(grep -P -o '\d+\.\d+\.\d+' src/ac.dats)"
    git push origin master
