project := 'whodatbot'

pip_compile := 'pip-compile -v'


_list:
  @just --list

develop:
  just install-dev-requirements
  pip install --upgrade-strategy=eager --editable .
  pip check

install-dev-requirements:
  pip install -r requirements.dev.txt

generate-dev-requirements +args='':
  rm requirements.txt || true
  PYTHONPATH=. {{pip_compile}} -o requirements.txt
  {{pip_compile}} -v requirements.dev.in -o requirements.dev.txt {{args}}
  rm requirements.txt

run +args='':
  python -m {{project}} {{args}}
