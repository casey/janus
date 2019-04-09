pwd = `pwd`

run:
  python3 src/main.py

# copy machine learning models to the assets folder
copy-model:
  cp exp/*.pkl assets/models

build:
  docker build -t simple-ml:latest .

run-image:
  docker run -d --rm --name simpleML \
    -p 8080:80 --env-file .env \
    -v {{pwd}}/assets:/app/assets \
    -v {{pwd}}/database/local.db:/app/local.db \
    simple-ml:latest

icombo: build run-image