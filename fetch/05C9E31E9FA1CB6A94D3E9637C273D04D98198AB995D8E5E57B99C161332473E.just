serve:
	basic-http-server

open:
	open http://127.0.0.1:4000

deps:
	cargo install basic-http-server
	curl https://code.jquery.com/jquery-3.4.1.min.js > jquery.js
	curl https://cdnjs.cloudflare.com/ajax/libs/remark/0.14.0/remark.min.js > remark.js
