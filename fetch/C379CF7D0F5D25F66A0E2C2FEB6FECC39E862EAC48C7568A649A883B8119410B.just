# Generate GraphQL code from graphql server schema
graph:
	just graph-app
	just graph-pub

graph-app:
	npx elm-graphql $API_HOST/app/graphql --base Api \
		--header "Authorization: Bearer $SYSTEM_JWT"

graph-pub:
	npx elm-graphql $API_HOST/pub/graphql --base ApiPub

elm:
	elm make src/App.elm
	rm index.html

elm-analyse:
	npx elm-analyse

elm-ts:
	npx elm-typescript-interop

elm-outdated:
	npx elm-outdated

test:
	npx elm-test

# This builds the bundle for production in `./dist`
build:
	rm -rf ./dist
	env API_HOST=$API_HOST_PROD npx parcel build src/index.html

start:
	npx parcel -p 8080 src/index.html

sg:
	npx parcel -p 9090 src/style-guide.html

# This has to be the same port as the FE
# Otherwise it won't find the token in LS
graphiql:
	npx parcel -p 8080 src/graphiql.html

net-login:
	netlify login

deploy: build
	env NETLIFY_SITE_ID=$NETLIFY_SITE_ID_APP netlify deploy --prod
