AWS_PROFILE="jallurodeo"
AWS_REGION="eu-central-1"

@default:
	just -l

# Log in to AWS ECR in docker and hyper
login:
	@echo docker: logging in to AWS ECR
	eval $(aws ecr get-login --no-include-email --region {{ AWS_REGION }} --profile {{ AWS_PROFILE }})
	
	@echo hyper: logging in to AWS ECR
	eval $(aws ecr get-login --no-include-email --region {{ AWS_REGION }} --profile {{ AWS_PROFILE }} | sed 's/docker/hyper/')
