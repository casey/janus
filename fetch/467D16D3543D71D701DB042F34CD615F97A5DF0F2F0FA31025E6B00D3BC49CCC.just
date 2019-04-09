# justfile, see: https://github.com/casey/just

open:
	open 'http://localhost'

serve:
	cd docs && sudo ../bin/serve

update:
	curl https://remarkjs.com/downloads/remark-latest.min.js > docs/remark.js
	curl https://code.jquery.com/jquery-3.2.1.min.js				 > docs/jquery.js
