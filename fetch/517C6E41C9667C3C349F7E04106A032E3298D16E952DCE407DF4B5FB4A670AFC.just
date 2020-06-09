# Link dotfiles with setup.py and pretty-print output.
link:
	which jq && ./setup.py | jq \
		|| ./setup.py

PIP_ARGS := "--disable-pip-version-check --user --progress-bar off"

# Install dependencies needed for `test`.
get-test-deps:
	python2 -m pytest --version \
		|| python2 -m pip install {{ PIP_ARGS }} pytest
	python3 -m pytest --version \
		|| python3 -m pip install {{ PIP_ARGS }} pytest

# Test setup.py on Py2 and Py3.
test:
	python2 -m pytest
	python3 -m pytest

# Lint setup.py with everything.
lint:
	mypy setup.py || true
	prospector setup.py || true
	bandit setup.py || true
	flake8 setup.py --doctests --max-line-length=135 || true
	pydocstyle --convention=google setup.py || true

# Install vscode extensions
vscode:
	cd ./.config/Code/User && ./install-extensions.sh