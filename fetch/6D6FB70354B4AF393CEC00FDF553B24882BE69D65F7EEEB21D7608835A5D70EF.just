build:
  bundle exec jekyll build

serve:
  bundle exec jekyll serve

update-content:
  # You can supply the API as an environment variable:
  # export DATO_API_TOKEN=abc123
  # or by creating a .env file containing 'DATO_API_TOKEN=abc123'.
  bundle exec dato dump

alias b := build
alias s := serve
alias dump := update-content
