help:
  cargo run --package cli-completion --bin cli-completion -- --help

generate-bash:
  cargo run --package cli-completion --bin cli-completion -- --bash commands/cli-completion.yaml

generate-zsh:
  cargo run --package cli-completion --bin cli-completion -- --zsh commands/cli-completion.yaml > /usr/local/share/zsh/site-functions/_cli-completion

generate-rsc:
  cargo run --package cli-completion --bin cli-completion -- --zsh commands/rsc.yaml > ~/.oh-my-zsh/custom/plugins/rsc/_rsc
