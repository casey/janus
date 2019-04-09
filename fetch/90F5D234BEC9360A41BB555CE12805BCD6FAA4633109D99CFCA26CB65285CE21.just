# run hugo server
preview:
	firefox "http://localhost:1313/"
	hugo serve -D --theme=hugo-wiki --disableFastRender

# open website
open:
	firefox "https://www.teddydd.me/"

# Show basic stats about website
@stats:
	echo "Repo size"
	du -hs .git
	echo "website size"
	hugo --quiet
	du -hs ./public/

# optimize png images
optimize:
	pushd static/images/
	oxipng -o 4 -i 1 --strip safe *.png
	popd

update-theme:
	pushd themes/hugo-wiki/
	git pull
	popd
	git add themes/hugo-wiki/

lint FILE:
	proselint {{FILE}} || true
	pandoc -s -i {{FILE}} -t plain | languagetool -l en -

# check stuff before publish
test:
	#!/usr/bin/env fish
	hugo
	liche ./public/**.html

# make sure liche is in newest version
update-liche:
	go get -u github.com/raviqqe/liche

