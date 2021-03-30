@all: pkgs minify

@pkgs:
	echo "Installing packages...";
	yarn;
	echo "Installed packages.";

@minify:
	echo "Minifying...";
	yarn babel-minify ./round-time-up.js --out-file ./round-time-up;
	echo "Minified.";

