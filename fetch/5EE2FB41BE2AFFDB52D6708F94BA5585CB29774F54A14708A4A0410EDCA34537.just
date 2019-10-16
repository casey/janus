PACKAGES := `fd . -t d -d 1 --exclude '**/{scripts,yarn}' | tr '\n' ' '`

brew:
  stow brew

install:
  stow -t ~ {{PACKAGES}} --no-folding

uninstall:
  stow -Dt ~ {{PACKAGES}}

list:
  @echo {{PACKAGES}}
