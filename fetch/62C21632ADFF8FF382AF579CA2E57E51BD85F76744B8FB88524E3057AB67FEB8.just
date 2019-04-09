dest = "/srv/http/myrrlyn/myrrlyn.net/build"
rsync_args = "-a -i -m -z --delete-delay --progress --inplace -e ssh"
target = "droplet"

# Build strips all non-tracked files in build/, such as signature files
build: install
	tsc
	sed -i.bk 's:^import .*$::' source/javascripts/*.js
	sed -i.bk 's:^ *export ::' source/javascripts/*.js
	rm source/javascripts/*.bk
	bundle exec middleman build

clean:
	rm -r build/

deploy: install
	# yes | bundle exec middleman rsync staging
	yes | bundle exec middleman rsync --no-build production

install:
	bundle install

serve: install
	bundle exec middleman serve

sign: build
	app/sign.sh

update:
	bundle update
	npm update
