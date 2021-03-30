version := "0.3.2"

package:
    wget https://github.com/manojkarthick/reddsaver/releases/download/v{{version}}/reddsaver-macos-amd64 -O reddsaver
    tar -czf reddsaver-mac.tar.gz reddsaver
    shasum -a 256 reddsaver-mac.tar.gz
    rm reddsaver

commit:
    git add -A
    git commit -m "Create release v{{version}}"
    git tag {{version}}
    git push -f origin master --tags

upload:
    github-upload-asset --owner manojkarthick --repo homebrew-reddsaver --release-tag {{version}} --asset-path reddsaver-mac.tar.gz --create-release
