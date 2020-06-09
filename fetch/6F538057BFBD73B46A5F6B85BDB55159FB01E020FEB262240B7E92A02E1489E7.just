# run instance
fg: buildout
	bin/instance fg

# install buildout
bootstrap:
        @make bin/buildout

# run buildout
buildout:
        @make bin/instance

# reset virtualenv
clean:
        rm -rf bin/ lib/ include/

# generate again from dhall
dhall:
	dhall to-directory-tree --file .dhall/init.dhall --output .
# vim: set ft=make :
