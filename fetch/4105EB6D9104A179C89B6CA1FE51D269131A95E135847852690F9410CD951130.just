build:
    pipenv run pelican 

serve:
    pipenv run pelican -lr

clean:
    rm -rf output
