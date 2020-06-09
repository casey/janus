MD_FILES := `find . -name *.md`

# Make all the things
all: toc fmt-md fmt-rego

# Generate TOC
toc:
	npx doctoc --no-title {{MD_FILES}}

# Format markdown
fmt-md:
	npx prettier --write {{MD_FILES}}

# Format rego
fmt-rego:
	opa fmt -w .

# Conftest Dockerfile
test-dockerfile:
	conftest \
		test \
		-i Dockerfile \
		-p ./docker/policy \
		./docker/Dockerfile*

# Conftest Kubernetes
test-kubernetes:
	conftest \
		test \
		-i yaml \
		-p ./kubernetes/policy \
		./kubernetes/deployment.yaml