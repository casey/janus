README:
	gpp -x README.src.md > README.md

install: README
	cp -f passwdgen ~/bin/passwdgen
	chmod +x ~/bin/passwdgen
