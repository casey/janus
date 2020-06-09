set shell := ["powershell.exe", "-c"]

build:
    just plugins_src/clean
    just plugins_src/build
    cargo build

install:
    cargo install --force --path .

clean:
    if (Test-Path target) { Remove-Item target -Recurse -ErrorAction Ignore }

changes:
    git log --pretty=format:%s | Out-File -FilePath CHANGELOG.md