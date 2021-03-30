package := "arkiv"
build_dir := "build/" + package

test:
 pytest

clean:
 rm -fr dist build {{package}}.egg-info __pycache__ .mypy_cache .pytest_cache .cache .eggs

build:
 python setup.py bdist_wheel

# TODO: zipapp has problems with readability-lxml
pack: build
 python -m pip install --upgrade -r requirements.txt --target {{build_dir}}
 python -m pip install --upgrade --target {{build_dir}} dist/{{package}}*.whl
 python -m zipapp {{build_dir}} -c -m "{{package}}.cli:main" -p "/usr/bin/env python3" -o dist/{{package}}
