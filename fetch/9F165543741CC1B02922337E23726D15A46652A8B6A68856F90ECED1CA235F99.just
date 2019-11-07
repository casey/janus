project := 'whodatbot'

_list:
  @just --list

develop:
  pip install --upgrade-strategy=eager --editable .

lint +args='':
  tox -e flake8 {{args}}

test +args='':
  tox -e pytest {{args}}

run +args='':
  python -m {{project}} {{args}}
