build:
	jekyll b
deploy: build
	sudo rsync -Pa _site/ /var/www/acm.umn.edu/ --delete
	sudo find /var/www/acm.umn.edu -type d -exec chmod 755 {} \;
	sudo find /var/www/acm.umn.edu -type f -exec chmod 644 {} \;
update:
	git pull
watch:
	jekyll s
