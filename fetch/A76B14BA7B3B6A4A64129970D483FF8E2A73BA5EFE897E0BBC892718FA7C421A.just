start: test
    electron .

run:
    ./node_modules/electron/dist/electron .

test: prep
    node ./build/tests/unit.js

prep: 
    npm install
    gulp build