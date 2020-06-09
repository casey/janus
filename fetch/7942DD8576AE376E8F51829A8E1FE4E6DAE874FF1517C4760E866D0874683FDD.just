# Just file: https://github.com/casey/just

release version:
    git tag {{version}}
    git checkout {{version}}
    git push --tags -f
    python3 setup.py sdist
    twine upload dist/code-grader-{{version}}.tar.gz
    git checkout master
    
