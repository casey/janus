alias r := run
alias install := push_watch
alias l := logs

push:
    clasp push

logs:
    clasp logs --watch --simplified

push_watch: push logs

run +FUNC:
    clasp run {{FUNC}}

test +TEST:
    clasp run {{TEST}}
    clasp logs --watch --simplified

login:
    clasp login --creds creds.json --no-localhost

lint:
    tslint *.ts
