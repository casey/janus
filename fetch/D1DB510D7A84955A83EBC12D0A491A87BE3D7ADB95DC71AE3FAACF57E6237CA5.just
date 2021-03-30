full-build:
	yarn generate
	yarn build
	cd integrations/webpack-loader && yarn tsc src/index.ts --outDir dist

# TODO: match actual build command
short-build:
	cd integrations/webpack-loader && yarn tsc src/index.ts --outDir dist

test:
	node examples/sucrase-cli/input.js
	cd examples/webpack && yarn webpack
	cd examples/create-react-app && yarn start

publish:
	yarn publish
	cd integrations/
