site_repo = "https://github.com/dhsavell/dhsavell.github.io.git"

build:
    hugo

serve:
    hugo serve -D

deploy: _setup_public build
    cd public; git add --all; git commit -m "Automatic deployment on: $(date --rfc-3339=seconds)"; git push origin master
    @echo Done.

_setup_public:
    if [ ! -d public/.git ]; then rm -rf public; git clone {{site_repo}} public; fi
