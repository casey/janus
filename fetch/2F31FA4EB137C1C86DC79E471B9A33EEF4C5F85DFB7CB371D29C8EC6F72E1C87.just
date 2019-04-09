# vim: set ft=make :

handler = 'handler.handler'
runtime = 'python3.6'
timeout = '30'
memory = '128'

env = 'dev'

help:
	@echo "just is a convenient command runner. Try just -l"


_compress:
	#!/bin/bash
	set -euo pipefail
	if test -f config/{{env}}.py ; then
	  cp config/{{env}}.py config.py
	fi
	echo "$({{get_current_commit}})" > git-commit.txt
	zip -r function.zip *.py git-commit.txt library/ vendor/ 1>/dev/null


_configure:
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"
	function_name="$(echo "$config" | jq -r '."function-name"')"

	aws lambda update-function-configuration \
		--function-name "$function_name" \
		--handler {{handler}} \
		--environment "$(echo "$config" | jq -c '{"Variables": .environment}')" \
		--vpc-config "$(echo "$config" | jq -c '."vpc-config"')" 1>/dev/null


deploy: compress configure
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"
	function_name="$(echo "$config" | jq -r '."function-name"')"

	aws lambda update-function-code \
		--function-name "$function_name" \
		--zip-file fileb://function.zip 1>/dev/null

	# Publishing a new Version of the Lambda function
	new_version=$(aws lambda publish-version --function-name "$function_name" | jq -r .Version)

	# Updating the Lambda Alias so it points to the new function
	aws lambda update-alias --function-name "$function_name" --function-version "$new_version" --name DEPLOYED 1>/dev/null

	just verify-commit "$({{get_current_commit}})"


get_current_commit = "git log --pretty=oneline -n 1 | awk '{print $1}'"


verify-commit commit='':
	#!/bin/bash
	set -euo pipefail

	if [[ -z "{{commit}}" ]] ; then
	    commit="$({{get_current_commit}})"
	else
	    commit="{{commit}}"
	fi

	output=$(just -q env={{env}} invoke "{\"verify-commit\": \"$commit\"}" | jq .)
	if [[ $(echo "$output" | jq -r .statusCode) != 200 ]] ; then
	  echo "$output"
	  exit 1
	else
	  echo "$output" | jq -r .body | jq .
	fi


invoke payload qualifier='$LATEST':
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"

	function_name="$(echo "$config" | jq -r '."function-name"')"
	aws lambda invoke \
		--function-name "$function_name" \
		--invocation-type RequestResponse \
		--log-type Tail \
		--payload '{{payload}}' --qualifier '{{qualifier}}' \
		lambda-invoke-output.txt | jq -r .LogResult | base64 -d > lambda-invoke-info.txt
	cat lambda-invoke-output.txt


# requries the key "cloudformation" in config/env.json
infrastructure:
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"
	cfn_stacks="$(echo "$config" | jq -c -r '.cloudformation')"

	if [[ -z "$cfn_stacks" ]] || [[ "$cfn_stacks" == null ]] ; then
	  exit 0
	fi

	function_name="$(echo "$config" | jq -r '."function-name"')"
	AWS_ENV_VARS=$(env | egrep '^AWS' | awk '{print "--env " $1}' | xargs echo || echo "")
	cfn_dir="$(pwd)/$(ls -l cfn | awk '{print $11}')"
	stackup="docker run $AWS_ENV_VARS -v $cfn_dir:/cfn --rm -v $(pwd):$(pwd) -w "$(pwd)" realestate/stackup:1.2.1"

	trap "rm -f cfn_params.json" EXIT
	for stack_key in $(echo "$cfn_stacks" | jq -r 'keys[]') ; do
		if ! output=$(aws cloudformation validate-template \
			--template-body "$(cat "cfn/$stack_key.yml")") ; then
		  echo "$output"
		  exit 1
		fi
		stack_name="$function_name-{{env}}-$stack_key"
	    echo "$cfn_stacks" | jq -c ".\"$stack_key\"" > cfn_params.json
		$stackup "$stack_name" up --template "/cfn/$stack_key.yml" \
			--parameters cfn_params.json
		# Wanted to use change sets, but encountered a non-zero exit code.
		# May still be useful for debugging, but they didn't add much additional insight
		#if ! $stackup "$stack_name" change-set create --name debug --template "/cfn/$stack_key.yml" \
		#	--parameters cfn_params.json ; then
		#  # After a change set failure it is stuck
		#  $stackup "$stack_name" delete
		#fi
		#$stackup "$stack_name" change-set create --name debug --template "/cfn/$stack_key.yml" \
		#	--parameters cfn_params.json
		#$stackup "$stack_name" change-set inspect --name debug
		#$stackup "$stack_name" change-set apply --name debug
		aws cloudformation describe-stacks --stack-name "$stack_name" | jq '.Stacks[] | .Outputs'
	done


setup: infrastructure _compress
	#!/bin/bash
	set -euo pipefail
	if ! test -f config/{{env}}.json ; then
	  echo "expected config file: config/{{env}}.json"
	  exit 1
	fi

	config="$(cat config/{{env}}.json)"
	function_name="$(echo "$config" | jq -r '."function-name"')"

	role="$(echo "$config" | jq -r '."role"')"
	# Create the versioned function
	aws lambda create-function --handler {{handler}} \
		--function-name "$function_name" \
		--zip-file fileb://function.zip \
		--runtime {{runtime}} --timeout {{timeout}} --memory-size {{memory}} --role "$role" \
		--environment "$(echo "$config" | jq -c '{"Variables": .environment}')" \
		--vpc-config "$(echo "$config" | jq -c '."vpc-config"')"
	aws lambda create-alias --name DEPLOYED \
		--function-name "$function_name" \
		--function-version '$LATEST'


destroy:
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"
	function_name="$(echo "$config" | jq -r '."function-name"')"

	aws lambda delete-function \
		--function-name "$function_name" \


schedule_expression = 'rate(5 minutes)'

# Schedule the lambda
# Add this to your setup task
schedule:
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"
	function_name="$(echo "$config" | jq -r '."function-name"')"
	schedule="${function_name}-schedule"

	# Schedule it
	rule=$(aws events put-rule \
		--name "$schedule" \
		--schedule-expression '{{schedule_expression}}' )
	aws lambda add-permission \
		--function-name "$function_name" \
		--statement-id "$schedule" \
		--action 'lambda:InvokeFunction' \
		--principal 'events.amazonaws.com' \
		--source-arn "$(echo "$rule" | jq -r .RuleArn)"
	function=$(aws lambda get-function --function-name "$function_name")
	aws events put-targets --rule "$function_name-schedule" \
	  --targets "Id"="1","Arn"="$(echo "$function" | jq .Configuration.FunctionArn)"


# Remove scheduling
# Add this to your destroy task
unschedule:
	#!/bin/bash
	set -euo pipefail
	config="$(cat config/{{env}}.json)"
	function_name="$(echo "$config" | jq -r '."function-name"')"
	schedule="${function_name}-schedule"

	aws lambda remove-permission \
		--function-name "$function_name" \
		--statement-id "$schedule" \
		|| echo "could not remove permission"
	aws events remove-targets --rule "$schedule" --ids 1 \
		|| echo "could not remove targets"
	aws events delete-rule \
		--name "$schedule" \
		|| echo "could not delete rule"
