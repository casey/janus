export PYTHON := "python3"
export VIRTUAL_ENV := env_var_or_default("VIRTUAL_ENV", "venv")

# Show this message and exit.
help:
    @just --list

# Remove all build artifacts.
{%- if cookiecutter.sphinx_documentation == 'yes' %}
clean: docs-clean
{%- else %}
clean:
{%- endif %}
    rm -rf build dist wheels
    find . \( -name *.pyc -o -name *.pyo -o -name __pycache__ -o -name *.egg-info \) -exec rm -rf {} +

# Create a virtualenv.
venv:
    #!/usr/bin/env sh
    if [ "$VIRTUAL_ENV" = "venv" ]; then
        case "$($PYTHON --version)" in
            "Python 3"*)
                $PYTHON -m venv venv;;
            *)
                virtualenv --python "$PYTHON" venv;;
        esac
    else
        echo "Not creating virtualenv because VIRTUAL_ENV is set."
    fi

# Install package.
install: venv
    $VIRTUAL_ENV/bin/pip install -e .

# Install package and CI dependencies.
install-ci: venv
    $VIRTUAL_ENV/bin/pip install -e ".[dev.lint,dev.test]"

# Install package and development dependencies.
install-dev: install-ci
    $VIRTUAL_ENV/bin/pip install{% if cookiecutter.sphinx_documentation == 'yes' %} sphinx{% endif %} twine

# Run all lints.
lint:
    $VIRTUAL_ENV/bin/flake8 --max-complexity 10

# Sort import statements according to the isort configuration.
sort-imports:
    $VIRTUAL_ENV/bin/isort --recursive

# Run all tests.
test:
    $VIRTUAL_ENV/bin/pytest -vv --cov={{ cookiecutter.slug }} --cov-report term-missing tests

# Build source and wheel package.
dist: clean
    $VIRTUAL_ENV/bin/python setup.py sdist bdist_wheel

# Package and upload a release.
release: dist
    $VIRTUAL_ENV/bin/twine upload dist/*

{%- if cookiecutter.sphinx_documentation == 'yes' %}
# Clean docs.
docs-clean:
    make -C docs clean

# Compile docs.
docs:
    make -C docs html

# Compile and open the docs.
docs-open: docs
	open docs/_build/html/index.html
{%- endif %}
