# wengwengweng

os = "darwin"
server = "t@wengwengweng"
folder = "zhuazhuazhua.me"
service = "zhuazhuazhua.me"
url = "https://www.zhuazhuazhua.me"

build: clean server scripts styles pages statics

server:
	mkdir dist
	env GOOS={{os}} go build -o dist/server server.go

statics:
	for f in favicon.ico img; do \
		rm -rf dist/statics/$f; \
		cp -r $f dist/statics/$f; \
	done

styles:
	for f in main; do \
		sass styles/$f.scss dist/statics/styles/$f.css; \
	done

scripts:
	for f in main; do \
		tsc scripts/$f.ts --outFile dist/statics/scripts/$f.js; \
	done

pages:
	mkdir -p .tmp
	go run photos.go
	pug -O .tmp/photos.json pages/main.pug --out dist/statics/pages
	rm -rf .tmp

clean:
	rm -rf dist

watch-pages:
	watchexec --exts pug "just pages"

watch-styles:
	watchexec --exts scss "just styles"

watch-scripts:
	watchexec --exts ts "just scripts"

run: build
	cd dist; \
		./server

deploy-statics:
	ssh {{server}} "rm -rf ~/{{folder}}/statics"
	cd dist; \
		rsync -av statics {{server}}:~/{{folder}} --exclude .DS_Store

deploy-server:
	cd dist; \
		rsync -av server {{server}}:~/{{folder}}
	ssh -t {{server}} "sudo systemctl restart {{service}}"

check:
	curl -s -m 3 --head --request GET {{url}}

open:
	open {{url}}

