build:
    python setup.py install build

install-dev:
    pip install -e .[development]

clean:
    python setup.py clean --all

fmt:
    autopep8 --aggressive --recursive --in-place ./process_cuwb_data/
