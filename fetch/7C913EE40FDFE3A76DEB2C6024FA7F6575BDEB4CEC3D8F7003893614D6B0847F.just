venv := env_var_or_default("VENV", "/home/tsm/.venv/juju_remove")
python := venv + "/bin/python"


# gets you ready for development
develop:
	sed -i -e '/PYTHON = /c\PYTHON = {{python}}' Makefile
	make requirements.txt
	{{python}} -m pip install -r requirements.txt
	{{python}} -m pip install -e .[dev]

# formats the code consistently
fmt:
	black --safe juju_remove.py

# removes build artifacts
clean:
	find . -type f -name *.pyc -delete
	find . -type f -name *.pyo -delete
	{{python}} setup.py clean

# removes everything
springclean:
	just clean
	rm -rf ./build
	rm -rf ./__pycache__
	rm -rf juju_remove.egg-info
