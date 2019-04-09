default:
	./test

# put symlinks to ansible-here into ~/bin
install:
	mkdir -p ~/bin
	ln -s $$PWD/ansible-here ~/bin/ansible-here
