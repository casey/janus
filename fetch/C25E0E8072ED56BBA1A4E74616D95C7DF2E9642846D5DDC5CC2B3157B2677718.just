test:
    PYTHONPATH=src python3 -m pytest

type:
    mypy src tests

lint:
    flake8 src tests
    black --line-length=79 --check src tests

format:
    black --line-length=79 src tests

check: test type lint
    tox

clean:
    rm -rf src/speakdata.egg-info build dist

build: clean
    python3 setup.py sdist bdist_wheel

publish: check build
    twine upload dist/*
