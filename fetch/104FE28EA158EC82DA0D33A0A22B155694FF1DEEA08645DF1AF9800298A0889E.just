image_repo = "jesse/coop"
image_tag = `git rev-parse --short HEAD`
image_name = image_repo + ":" + image_tag
test_cmd = "truffle test"

build:
	docker build -t {{image_name}} .


test: build ganache
	docker run --net host {{image_name}} {{test_cmd}}


env +argv: build
        docker run --rm --net host -it -v `pwd`:/app {{image_name}} {{argv}}


ganache:
        docker run -d --rm --name ganache --net host trufflesuite/ganache-cli || true
