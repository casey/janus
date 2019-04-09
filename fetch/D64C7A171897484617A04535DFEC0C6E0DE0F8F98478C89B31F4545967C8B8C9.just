deploy:
	bin/deploy

build:
	bin/build

check:
	aws cloudformation deploy --no-execute-changeset --stack-name $APP_NAME

url:
	aws cloudformation describe-stacks --stack-name $APP_NAME --query 'Stacks[0].Outputs[0].OutputValue' --output text

test:
	curl -X POST `just url`

check-error:
	aws cloudformation describe-stack-events --stack-name $APP_NAME

stacks:
	aws cloudformation list-stacks

delete:
	aws cloudformation delete-stack --stack-name $APP_NAME

