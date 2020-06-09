help:
    @just -l

bucket:
	#!/bin/bash
	BUCKET_ID=$(dd if=/dev/random bs=8 count=1 2>/dev/null | od -An -tx1 | tr -d ' \t\n')
	BUCKET_NAME=lambda-wankilext-artifacts-$BUCKET_ID
	echo $BUCKET_NAME > bucket-name.txt
	aws s3 mb s3://$BUCKET_NAME

build:
	#!/bin/bash
	cd function
	GOOS=linux go build main.go

clean:
	#!/bin/bash
	rm -rf function/main

deploy:
	#!/bin/bash
	aws cloudformation package --template-file template.yml --s3-bucket $(cat bucket-name.txt) --output-template-file out.yml
	aws cloudformation deploy --template-file out.yml --stack-name wankil-ext-stream-faas --capabilities CAPABILITY_NAMED_IAM

do-it:
    @just build
    @just deploy
