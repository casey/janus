export NODE_OPTIONS := "--no-warnings"


# Variables
# ---------

node_bin 		:= "./node_modules/.bin"
src_dir 		:= "./src"



# Tasks
# -----

@default: css-large
	just watch-css & npm run dev


build-production:
	@rm -rf dist
	@npm run build

	@# Gzip everything
	gzip --best --recursive --keep dist/

	@# Css
	@rm dist/application.css
	@just css-small
	@cp static/application.css dist/application.css

	@# ipfs-404.html
	rm dist/ipfs-404.html || true
	@cp dist/ipfs-404/index.html dist/ipfs-404.html


@elm-housekeeping:
	echo "> Running elm-impfix"
	{{node_bin}}/elm-impfix "{{src_dir}}/**/*.elm" --replace
	echo "> Running elm-format"
	elm-format {{src_dir}} --yes


install-deps:
	@npm install
	{{node_bin}}/elm-git-install


@watch-css:
	echo "👀  Watching CSS"
	watchexec -p -w css -e "css,js" -- just css-large


@upgrade-deps:
	echo "⬆️  Upgrading Elm Dependencies"
	elm-json upgrade --unsafe
	echo "⬆️  Upgrading Js Dependencies"
	npm update
	npm outdated
	echo "👀 Please review the output above and optionally upgrade some packages to newer major versions with `npm install package@latest`"



# Parts
# -----

@css-large:
	echo "⚙️  Compiling CSS & Elm Tailwind Module"
	node ./css/Build.js


@css-small:
	echo "⚙️  Compiling Minified CSS"
	NODE_ENV=production node ./css/Build.js
