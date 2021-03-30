@all: pkgs tsc browserify minify finish

@pkgs:
	echo "Installing packages...";
	yarn;
	echo "Installed packages.";

@tsc:
	echo "Compiling TypeScript...";
	yarn tsc;
	echo "Compiled TypeScript.";

@browserify:
	echo "Browserifying JavaScript...";
	yarn browserify ./index.js --node --bare -o ./index.bundle.js;
	echo "Browerified JavaScript.";

@minify:
	echo "Minifying...";
	yarn babel-minify ./index.bundle.js --out-file ./index.min.js;
	echo "Minified.";

@finish:
	echo "Finishing up...";
	node ./make.js;
	echo "Finished up.";

