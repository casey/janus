tar:
	nix-build -A tar --out-link changelog.tar.gz

dir:
	nix-build -A dir --out-link changelog

dir-pdf:
	nix-build -A dir-pdf --out-link changelog
