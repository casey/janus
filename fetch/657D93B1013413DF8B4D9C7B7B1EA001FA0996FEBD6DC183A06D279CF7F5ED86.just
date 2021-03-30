help:
  @just --list

serve:
  hugo server --buildDrafts --verbose

deploy:
  #!/usr/bin/env bash
  TAG="`git log -1 --pretty=%B`"
  echo "Deploying with tag... $TAG"
  sleep 5
  hugo -D
  cd public
  git add .
  git commit -m "$TAG"
  git push
  echo "Successfully deployed $TAG"

update-template:
	git submodule foreach git pull origin master
