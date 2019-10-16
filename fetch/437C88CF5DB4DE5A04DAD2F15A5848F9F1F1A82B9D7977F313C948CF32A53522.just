bin_name = "local-domain-alias"
release_dir = `echo ${HOME}/.cargo/bin`

install:
    cargo install --path . --force
    sudo chown root:root {{release_dir}}/{{bin_name}}
    sudo chmod u+s {{release_dir}}/{{bin_name}}
