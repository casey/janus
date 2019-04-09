export ZDOTDIR = './'

sloc:
	@printf "www: "
	@cd www && cat `find -E . \
		-regex '.*[.](js|glsl|css|html)' \
		-not -path './lib/*' \
		-not -path './srv/lib/*'` \
		| sed '/^\s*$$/d' | wc -l

build:
	@./bin/build

push: build
	@./bin/push

push-old:
	rsync -avz --delete --delete-excluded --perms --progress --exclude-from=./exclude \
		./ romrador.com:/srv/www/romrador/

serve:
	sudo node server/main.js
