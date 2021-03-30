env:
    pipenv shell

run:
    python3 main.py

devinst:
    pipenv install --dev pylint

load:
    pipenv install -r requirements.txt && pipenv install -r dev-requirements.txt --dev

lock:
    pipenv lock -r > requirements.txt && pipenv lock -r -d > dev-requirements.txt