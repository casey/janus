env:
    pipenv shell && pipenv update

update:
    pipenv update

run:
    python main.py

devinst:
    pipenv install --dev pylint

load:
    pipenv install -r requirements.txt && pipenv install -r dev-requirements.txt --dev

lock:
    pipenv lock -r > requirements.txt && pipenv lock -r -d > dev-requirements.txt