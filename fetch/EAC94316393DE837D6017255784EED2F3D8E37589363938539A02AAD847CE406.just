export PUBLIC_URL="https://ka3xr15hdi.execute-api.us-east-2.amazonaws.com/running/showMeTheCurrency"

build-js:
  yarn build

build-python:
  cp lambda_function.py build

build-zip:
  #!/bin/bash
  cd build
  zip -r deploy.zip *

build: build-js build-python build-zip

deploy: 
  aws lambda update-function-code --function-name showMeTheCurrency --zip-file fileb://build/deploy.zip 

combo: build deploy