build_name = "jesse/bmiller.com"
site_name = `cat CNAME`


# Build the environment
build:
	docker build -t {{build_name}} .


# Generate the static files
generate: build
	docker run -it -v `pwd`/_site:/out {{build_name}}


# deploy to netlify by pushing to github
deploy: generate
	git add _site/*
	git commit -am 'deploying to netlify'
	git push
