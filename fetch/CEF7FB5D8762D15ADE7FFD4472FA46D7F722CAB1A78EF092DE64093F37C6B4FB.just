# Install all config
install-all: install-fish install-git install-hyper
	@echo '✓ All config installed'

# Install fish config
install-fish:
	@cp -r fish/ ~/.config/fish/
	@echo '✓ Fish config installed'

# Install git config
install-git:
	@cp git/gitignore-global ~/.gitignore-global
	@git config --global core.excludesfile ~/.gitignore-global
	@echo '✓ Git config installed'

# Install hyper config
install-hyper:
	@cp hyper/hyper.js ~/.hyper.js
	@echo '✓ Hyper config installed'
