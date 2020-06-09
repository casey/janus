
# Variables
# ---------

project_dir			:= invocation_directory()
template_dir		:= "."
build_dir_name  := "build"

bin 						:= project_dir + "/node_modules/.bin"
build_dir 			:= project_dir + "/" + build_dir_name
src_dir					:= project_dir + "/src"



# Default task
# ------------

@default: build
	cd {{project_dir}}; \
		just icidasset-template/watch & \
		just icidasset-template/server



# Tasks
# -----

@build: clean system elm css
	echo "> Build completed ⚡"


@build-production: clean system elm-prod css-prod


@clean:
	echo "> Cleaning build directory"
	rm -rf {{build_dir}}
	mkdir -p {{build_dir}}


@css:
	echo "> Compiling Css"
	{{bin}}/postcss \
		"{{src_dir}}/Css/Main.css" \
		--output "{{build_dir}}/stylesheet.css" \
		--config "{{template_dir}}/Css/"


@css-prod:
	echo "> Compiling Css (optimized)"
	NODE_ENV=production {{bin}}/postcss \
		"{{src_dir}}/Css/Main.css" \
		--output "{{build_dir}}/stylesheet.css" \
		--config "{{template_dir}}/Css/"


@elm:
	echo "> Compiling Elm application"
	cd {{project_dir}}; elm-make {{src_dir}}/App/Main.elm --output {{build_dir}}/application.js


@elm-prod:
	echo "> Compiling Elm application (optimized)"
	cd {{project_dir}}; elm-make {{src_dir}}/App/Main.elm --output {{build_dir}}/application.js

	{{bin}}/terser {{build_dir}}/application.js \
		--output {{build_dir}}/application.tmp.js \
		--compress --mangle

	rm {{build_dir}}/application.js
	mv {{build_dir}}/application.tmp.js {{build_dir}}/application.js


@server:
	echo "> Booting up web server on port 8000"
	devd --port 8000 --all --crossdomain --quiet --notfound=200.html {{build_dir}}


@system:
	echo "> Compiling System"
	cd {{project_dir}}; stack build --fast && stack exec build


@watch:
	cd {{project_dir}}; \
		just icidasset-template/watch-css & \
		just icidasset-template/watch-elm & \
		just icidasset-template/watch-system


@watch-css:
	echo "> Watching CSS"
	cd {{project_dir}}; \
		watchexec -p -i "{{build_dir_name}}/*" --exts "css" -- \
		just icidasset-template/css


@watch-elm:
	echo "> Watching Elm"
	cd {{project_dir}}; \
		watchexec -p -i "{{build_dir_name}}/*" --exts "elm" -- \
		just icidasset-template/elm


@watch-system:
	echo "> Watching System"
	cd {{project_dir}}; \
		watchexec -p -i "{{build_dir_name}}/*" --exts "hs,js,md,yaml" -- \
		just icidasset-template/system
