down:
    docker-compose down

up:
    docker-compose up -d

build:
    pipenv run smdb build

restart container:
    docker-compose restart {{container}}

logs container:
    docker-compose logs {{container}}

generate-client host:
    pipenv run smdb manage make_js_interface {{host}} api.js
    mv backend/app/api.js frontend/middleware/api.js

yarn +ARGS:
    cd $HOME/repositories/sheet_music_database/frontend && yarn {{ARGS}}

smdb +ARGS:
    pipenv run smdb {{ARGS}}

create-account email:
    docker-compose up -d
    coreapi get http://localhost:8000/docs
    coreapi action auth registration create -p email={{email}} -p password1=this\ is\ a\ test -p password2=this\ is\ a\ test

test:
    cd $HOME/repositories/sheet_music_database/frontend && yarn test 
    pipenv run smdb test -m 

format:
    black .
    cd $HOME/repositories/sheet_music_database/frontend && npx eslint --fix {components,reducers,actions,middleware}/**

crcf name +ARGS='':
    cd $HOME/repositories/sheet_music_database/frontend && yarn crcf {{ARGS}} components/{{name}}

tf:
    cd $HOME/repositories/sheet_music_database/frontend && yarn test -u --lastCommit

test-frontend:
    cd $HOME/repositories/sheet_music_database/frontend && yarn test -u --lastCommit

tb:
    pipenv run smdb test

test-backend:
    pipenv run smdb test
