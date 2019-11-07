# Build website.
build:
  zola build

# Test website using a test server.
serve:
  zola serve

# Build and deploy website.
deploy: build
  rsync -zlHxihrptuv public/ freebsd@wdj-consulting.com:/usr/local/www/site
