
# List recipes
@default:
  just -l

install:
  npm install -g yarn

add-resin-remote:
  git remote add resin gh_venuusaur@git.resin.io:gh_venuusaur/radiator.git

deploy:
  git push resin

@resin +args='':
  ./node_modules/.bin/resin {{ args }}

# Scan for resin devices on local network
scan:
  sudo just resin local scan

# SSH into a local device running resin
ssh:
  sudo just resin local ssh --host

# Push changes in to Dockerfile to a local resin device
push:
  sudo just resin local push -s .
