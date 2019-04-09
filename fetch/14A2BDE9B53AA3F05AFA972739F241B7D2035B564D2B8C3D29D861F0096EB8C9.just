build:
	node build.js

deploy:
	git push && git push live

clean:
	rm -rf public

daemon:
	pm2 start --name BlogServer server.js

halt:
	pm2 stop BlogServer

dev-daemon:
	pm2 start nodemon --name DevBlogServer -- server.js

dev-halt:
	pm2 stop DevBlogServer

dev: dev-daemon
	node build --watch && just dev-halt
