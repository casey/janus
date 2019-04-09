
build_path = 'public'
site_id = 'anna-eevert-love'

default:
  just -l

install:
  npm install -g gatsby-cli netlify-cli yarn

dev:
  gatsby develop

clean:
  rm -rf {{build_path}}/*

build: clean
  gatsby build

deploy: build
  netlify deploy --path {{build_path}} --site-id {{site_id}}

convert-to-hero input output:
  convert \
    "{{ input }}" \
    -quality 75 \
    -geometry 2880x1920^ \
    -gravity center \
    -crop 2880x1920+0+0 \
    "{{ output }}"
