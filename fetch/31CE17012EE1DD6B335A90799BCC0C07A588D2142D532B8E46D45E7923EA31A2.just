default := 'check test'

build_dir := "build/jackup"

check:
 mypy jackup

test:
 pytest

clean:
 rm -fr dist build jackup.egg-info __pycache__ .mypy_cache .pytest_cache .cache .eggs

build:
 python setup.py bdist_wheel

pack:
 python -m pip install --upgrade -r requirements.txt --target {{build_dir}}
 python -m pip install --upgrade --target {{build_dir}} dist/jackup*.whl
 python -m zipapp {{build_dir}} -c -m "jackup.cli:main" -p "/usr/bin/env python3" -o dist/jackup

pex:
 pex -r requirements-pex.txt -m "jackup.cli:main" -o dist/jackup.pex
