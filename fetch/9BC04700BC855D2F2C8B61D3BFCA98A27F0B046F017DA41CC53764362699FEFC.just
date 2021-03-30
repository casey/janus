#!/usr/bin/env just --justfile

## ----------------------------------------------------------------------------
## This is a justfile (like make) [https://github.com/casey/just]
## Managing terraform deployment with environment agnostic docker based runtime
##
## Highlights:
## - can run different terraform version with just a change of DOCKER_IMAGE
## - using best practices
## -- always using remote state by default
##
## ----------------------------------------------------------------------------

AWS_ACCOUNT_ID := `aws sts get-caller-identity --query 'Account' --output text || echo '[Error] No valid AWS account session/credentials found. Pleas login first.' || exit 2`
# gets the current active region
AWS_REGION := `aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'`
export AWS_DEFAULT_REGION := AWS_REGION

TF_STATE_BUCKET := 'terraform-states-' + AWS_ACCOUNT_ID + '-' + AWS_REGION
TF_STACK_NAME := '{{cookiecutter.project_slug}}'

{%- if cookiecutter.use_docker == "y" %}
## ----------------------------------------------------------------------------
## DOCKER runtime related
## ----------------------------------------------------------------------------

DOCKER_IMAGE := 'hashicorp/terraform:light'

DOCKER_MOUNTS := justfile_directory() + '/..:' +  justfile_directory() + '/..'
DOCKER_WORKDIR := justfile_directory()

DOCKER_ENV_ARGS := '-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_ACCOUNT_ID -e AWS_DEFAULT_REGION=' + AWS_DEFAULT_REGION + ' -e AWS_PROFILE -e AWS_DEFAULT_PROFILE'
DOCKER_ARGS := DOCKER_ENV_ARGS + ' -v ' + DOCKER_MOUNTS + ' -w ' + DOCKER_WORKDIR + ' -t  ' + DOCKER_IMAGE
{%- endif %}

_default:
	@just --list

## ----------------------------------------------------------------------------
## HELPERS
## ----------------------------------------------------------------------------

# Displays given text in color.
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

_status text:
	#!/usr/bin/env bash
	echo -e "\e[34m\e[1m[*] {{ "{{" }}text{{ "}}" }}"

## ----------------------------------------------------------------------------
## TARGETS - standard
## ----------------------------------------------------------------------------
# prints important variables
info:
	@echo '------------- info -----------------------------------------------------------------'
	@echo "[>] remote state: s3://{{ "{{" }}TF_STATE_BUCKET{{ "}}" }}/{{ "{{" }}TF_STACK_NAME{{ "}}" }}.json"
{%- if cookiecutter.use_docker == "y" %}
	@echo "[>] Terraform version: `docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} '-version'`"
{%- endif %}
	@just --evaluate
{%- if cookiecutter.use_docker == "n" %}
	@echo '[>] all exported: TF_* '
	@echo `export | grep TF_`
	@echo '[<]'
{%- endif %}
	@echo '-------------------------------------------------------------------------------------'

# terraform init w/ remote state
init:
	@just _status "Initializing terraform with remote state: 's3://{{ "{{" }}TF_STATE_BUCKET{{ "}}" }}/{{ "{{" }}TF_STACK_NAME{{ "}}" }}.json' ..."
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }}  \
{%- else %}
	terraform \
{%- endif %}
	init -backend-config="bucket={{ "{{" }}TF_STATE_BUCKET{{ "}}" }}" -backend-config="key={{ "{{" }}TF_STACK_NAME{{ "}}" }}.json"

alias build := plan
alias autolint := fmt
alias lint := validate
alias deploy := apply
alias undeploy := destroy

# not implemented yet
test:
	@echo "[] Test not implemented."

clean:
	@rm -fr .terraform
	@rm -f .terraform.lock.hcl


## ----------------------------------------------------------------------------
## TARGETS - terraform
## ----------------------------------------------------------------------------

## terraform init w/ local state
local:
	@just _status 'Initializing terraform with local state ...'
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} init
{%- else %}
	terraform init
{%- endif %}

# executes terraform apply w/ auto-approve
apply:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} apply -auto-approve
{%- else %}
	terraform apply -auto-approve
{%- endif %}

# executes terraform destroy w/ force
destroy:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} destroy -force
{%- else %}
	terraform destroy -force
{%- endif %}

# executes terraform plan
plan:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} plan
{%- else %}
	terraform plan
{%- endif %}

# updates tf configurations in the current directory for easy readability and consistency
fmt:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} fmt
{%- else %}
	terraform fmt
{%- endif %}

# check and report errors within tf modules, attribute names, and value types
validate:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} validate
{%- else %}
	terraform validate
{%- endif %}

# executes terraform show
show:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} show
{%- else %}
	terraform show
{%- endif %}

# executes terraform state w/ given subcommand
state *subcommand:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} state {{ "{{" }}subcommand{{ "}}" }}
{%- else %}
	terraform state {{ "{{" }}subcommand{{ "}}" }}
{%- endif %}

# executes terraform output
output *args:
{%- if cookiecutter.use_docker == "y" %}
	@docker run -i {{ "{{" }}DOCKER_ARGS{{ "}}" }} output {{ "{{" }}args{{ "}}" }}
{%- else %}
	terraform output {{ "{{" }}args{{ "}}" }}
{%- endif %}
