venv := "venv"
PYTHONPATH := "."
PYTHON := venv + "/bin/python"

test:
	. venv/bin/activate
	PYTHONPATH={{PYTHONPATH}} pytest

check path +FLAGS='':
	. venv/bin/activate
	PYTHONPATH={{PYTHONPATH}} {{PYTHON}} tools/check_links.py {{path}} {{FLAGS}}

validate path +FLAGS='':
	. venv/bin/activate
	PYTHONPATH={{PYTHONPATH}} {{PYTHON}} tools/validate_pubs.py {{path}} {{FLAGS}}

status host +FLAGS='':
	. venv/bin/activate
	PYTHONPATH={{PYTHONPATH}} {{PYTHON}} tools/status.py {{host}} {{FLAGS}}

provision host +FLAGS='':
	. venv/bin/activate
	PYTHONPATH={{PYTHONPATH}} {{PYTHON}} tools/provision.py {{host}} {{FLAGS}}

deploy host +FLAGS='':
	. venv/bin/activate
	PYTHONPATH={{PYTHONPATH}} {{PYTHON}} tools/deploy.py {{host}} {{FLAGS}}
