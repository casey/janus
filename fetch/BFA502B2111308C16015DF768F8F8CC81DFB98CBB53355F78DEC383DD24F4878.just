setup_file = "setup.py"

# install dependencies
install:
    pip install -r requirements.txt

# build stuff
build:
    rm -rf ./dist
    python {{setup_file}} bdist_wheel

# deploy stuff
deploy: build
    twine upload dist/*