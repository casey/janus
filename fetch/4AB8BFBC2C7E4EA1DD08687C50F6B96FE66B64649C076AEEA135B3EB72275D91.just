include_dir = '~/.txn/include'
package_dir = '~/.txn/package'

build:
	mktxn

install:
	install -dm 700 {{include_dir}} {{package_dir}}
	install -Dm 644 *.txn -t {{include_dir}}
	cp -R includes {{include_dir}}
	install -Dm 644 *.txn.pkg.tar.xz -t {{package_dir}}

# vim: set filetype=make foldmethod=marker foldlevel=0:
