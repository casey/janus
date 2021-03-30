test:
	python -m pytest

clean:
	rm -rf build dist src/*.egg-info .tox .pytest_cache pip-wheel-metadata .DS_Store
	find src -name '__pycache__' | xargs rm -rf
	find tests -name '__pycache__' | xargs rm -rf

install:
	python -m pip install -e .

dev:
	python -m pip install -e .[dev]

dist: clean
	git diff --exit-code			# Check for unstaged changes
	git diff --exit-code --cached	# Check for uncommitted changes
	check-manifest
	python setup.py sdist bdist_wheel

release: dist
	twine upload dist/*.*

run:
	uvicorn beaniecocktails:app --reload --debug