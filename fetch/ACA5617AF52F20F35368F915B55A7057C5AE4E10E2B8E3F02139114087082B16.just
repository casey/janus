@help:
  just --list


# Serve files
serve:
  @echo "Service files at http://$(ipconfig getifaddr en0):8080/"
  @docker run --rm -p $(ipconfig getifaddr en0):8080:80 -v $(pwd)/docs:/usr/share/nginx/html:ro nginx


# Start development build
start:
  yarn start


# Build production
build:
  yarn build


# Build, commit and push
deploy comment: build
  git add .
  git ci -m "{{ comment }}"
  git push
