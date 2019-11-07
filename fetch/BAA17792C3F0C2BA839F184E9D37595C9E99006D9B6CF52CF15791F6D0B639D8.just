# wengwengweng

os := "darwin"
port := "8000"
mode := "debug"
server := "tga@bastardstickweed"
dir := "~/sites/zhuazhuazhua.me"
service := "zhuazhuazhua.me"
url := "zhuazhuazhua.me"
statics := "pages lib img files fonts"
pages := "main about pet work"

@build: clean build-server build-statics

@run: build
	echo "+ running server"
	cd dist; \
		./server {{port}}

@build-server:
	echo "+ building server"
	mkdir dist
	env GOOS={{os}} go build -o dist/server src/*.go

@build-statics: build-styles build-scripts copy-statics

@copy-statics:
	echo "+ copying statics"
	for f in {{statics}}; do \
		rm -rf dist/statics/$f; \
		cp -r $f dist/statics/$f; \
	done

@build-styles:
	echo "+ building styles"
	for f in {{pages}}; do \
		sass styles/$f.scss dist/statics/styles/$f.css; \
	done

@build-scripts:
	echo "+ building scripts"
	if [ {{mode}} = "prod" ]; then \
		for f in {{pages}}; do \
			webpack -p scripts/$f.js -o dist/statics/scripts/$f.js; \
		done \
	else \
		for f in {{pages}}; do \
			px -E scripts/$f.js dist/statics/scripts/$f.js; \
		done \
	fi

@clean:
	echo "+ cleaning"
	rm -rf dist

@watch-statics:
	echo "+ watching statics"
	watchexec -w styles -w scripts -w pages -w lib -w img -w files "just build-statics"

@deploy: deploy-server deploy-statics

@deploy-server:
	just os=linux
	echo "+ deploying server"
	cd dist; \
		rsync -av server {{server}}:{{dir}} --exclude .DS_Store
	ssh -t {{server}} "sudo systemctl restart {{service}}"

@deploy-statics: build-statics
	echo "+ deploying statics"
	cd dist; \
		rsync -av statics {{server}}:{{dir}} --exclude .DS_Store --delete

@fetch-libs:
	echo "+ fetching libs"
	mkdir -p lib
	wget -O lib/mithril.min.js https://unpkg.com/mithril/mithril.min.js

@update:
	git submodule foreach "(git pull)"

@req:
	http {{url}}

