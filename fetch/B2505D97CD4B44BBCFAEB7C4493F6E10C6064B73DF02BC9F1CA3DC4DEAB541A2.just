build-docker:
  docker build -t phost .

run-docker:
  docker kill phost || true
  docker rm phost || true
  docker run -d --name phost -p 7645:80 -p 5855:5855 -v /opt/phost:/var/www/hosted -e DB_USERNAME=$DB_USERNAME -e DB_PASSWORD=$DB_PASSWORD -e DB_HOST=$DB_HOST -e DB_DATABASE=$DB_DATABASE -e DATABASE_URL=$DATABASE_URL -e PROXY_SERVER_LOG_FILE=$PROXY_SERVER_LOG_FILE -e PROTOCOL=$PROTOCOL -e ROOT_URL=$ROOT_URL -e HOST_PATH=$HOST_PATH phost
