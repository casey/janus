build:
    pip install -e .

install-dev:
    pip install -e .[development]

fmt:
    autopep8 --aggressive --recursive --in-place ./groundtruth_utils/
