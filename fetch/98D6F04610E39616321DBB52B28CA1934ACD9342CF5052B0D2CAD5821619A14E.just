# just docs: https://github.com/casey/just



set shell := ["bash", "-c"]

# Avoid ../../../../foo type paths by hard-coding the repository root turning paths into e.g. /repo/cloud/foo
export ROOT                           := env_var_or_default("GITHUB_WORKSPACE", `git rev-parse --show-toplevel`)
export GOOGLE_APPLICATION_CREDENTIALS := ROOT + "/cloud/.provider/gcp/terraform-admin.json"
export GOOGLE_ORGANIZATION_JSON       := ROOT + "/cloud/.provider/gcp/organization.json"

root                                  := "< .cloudseed/cloud/lib/provider/gcp/>"

bold          := '\033[1m'
normal        := '\033[0m'
green         := "\\e[32m"
yellow        := "\\e[33m"
magenta_light := "\\e[92m"

# If not in docker, get inside
_help:
    #!/usr/bin/env bash
    if [ -f /.dockerenv ]; then
        echo "🌱 Cloudseed 🌱"
        echo "   Google Compute Engine (gcp) initialization and configuration"
        echo "      See ./playbook.md"
        echo ""
        just --list --unsorted
        echo ""
        echo -e "   🌱 Cloudseed terraform admin GCE service account: {{bold}}cloudseed-terraform-admin@$(just _terraform_project_id).iam.gserviceaccount.com{{normal}}"
        echo ""
    else
        just ../../_docker
    fi

# 🌱 What is the status of the provider? Authenticated, backend set up, etc
output:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -f $GOOGLE_ORGANIZATION_JSON ]; then
        error="❗🚪 provider is not initialized, cannot find $GOOGLE_ORGANIZATION_JSON 🚪"
        fix="just $ROOT/cloud/lib/provider/gcp/initialize"
        docs="See for requirements ➡ $ROOT/cloud/lib/provider/gcp/readme.md"
        echo -e "{\"error\":\"$error\", \"fix\":\"$fix\", \"docs\":\"$docs\"}" | jq .
        exit 1;
    fi
    just _terraform_project_service_account_key_required
    TERRAFORM_PROJECT=$(cat /repo/cloud/env/.provider/gcp/organization.json | jq -r '.sops.gcp_kms[0].resource_id' | awk -F\/ '{printf("%s\n", $2)}')
    just decrypt $GOOGLE_ORGANIZATION_JSON | jq --arg terraform_project_id "${TERRAFORM_PROJECT}" '. + {terraform_project_id: $terraform_project_id}'

# 1. authenticates with your root account (e.g. me@company.com)
# 2. creates the terraform project: `<gitowner>__<gitrepo>_<hash>` and links it to the billing account (see [reference](https://joachim8675309.medium.com/terraforming-gcp-part-1-creating-an-admin-project-5dc2298bcf7a))
# 3. creates the service account `cloudseed-terraform-admin@<TERRAFORM_PROJECT>.iam.gserviceaccount.com`
# 4. creates a bucket for terraform remote state
# 5. ➡ downloads a credential for the terraform service account: `cloud/env/.provider/gcp/terraform-admin.json`
# 6. ➡ stores encrypted provider data required by deployments:  `cloud/env/.provider/gcp/organization.json`
# 🌱 Set up the GCE admin terraform account+project for CI operations. Idempotent. You should only need to run this once.
initialize: root_account_authenticate
    #!/usr/bin/env bash
    # exit when any command fails
    set -euo pipefail

    # Assume if the service account key already exists then initialization ok, all steps were performed without errors
    if [ -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
        echo -e "🚪 👍 cloud provider (gcp/google) already initialized 🚪"
        exit 0
    fi

    if [ "$(gcloud organizations list --format json)" = "[]" ]; then
        echo -e "🚪 Found no organizations 🚪"
        echo -e "🚪 See playbook.md##Initialization 🚪"
        exit 1;
    fi

    # We store and encrypt the root user email so we can add it later as an owner
    # for the singular reason to view console+dashboards in https://console.cloud.google.com/
    # (see cloud/lib/terraform/app/gcp/project/main.tf#google_project_iam_member.allow_root_account_visibility)
    ROOT_OWNER_EMAIL=$(gcloud auth list --format json | jq -r '.[] | select( .status == "ACTIVE") | .account')

    #############################################################################################################################
    # create the terraform service account (project), which will be used to create all deployments (each a separate gcp project)
    #############################################################################################################################
    # This generates a new project name
    export TERRAFORM_PROJECT_NAME="$(deno run --unstable --allow-all ${CLOUDSEED_DENO_ROOT}/cloudseed/gcp/gcloud_terraform_project_id.ts)"
    export TERRAFORM_ADMIN_ACCOUNT="cloudseed-terraform-admin@${TERRAFORM_PROJECT_NAME}.iam.gserviceaccount.com"
    GCP_ORGANIZATION_NAME=$(gcloud organizations list --format json | jq -r '.[0].displayName')
    GCP_ORGANIZATION_ID=$(gcloud organizations list --format json | jq -r '.[0].name' | cut -d/ -f2)
    GCP_BILLING_ACCOUNT_ID=$(gcloud beta billing accounts list --format json | jq -r '.[0].name' | cut -d/ -f2)

    # Taken from: https://joachim8675309.medium.com/terraforming-gcp-part-1-creating-an-admin-project-5dc2298bcf7a

    # If the project was already created, assume all the following steps were successful
    if gcloud projects list | grep -q "${TERRAFORM_PROJECT_NAME}"; then
        echo -e "🚪 👍 {{bold}}${TERRAFORM_PROJECT_NAME}{{normal}} :found existing project 🚪"
        exit 0;
    fi

    echo -e "🚪 {{root}} {{bold}}gcloud projects create ${TERRAFORM_PROJECT_NAME} --organization ${GCP_ORGANIZATION_ID} --set-as-default {{normal}}🚪 "; \
    gcloud projects create ${TERRAFORM_PROJECT_NAME} --organization ${GCP_ORGANIZATION_ID} --set-as-default

    echo -e "🚪 Link Project to Billing Account 🚪"
    gcloud beta billing projects link ${TERRAFORM_PROJECT_NAME} --billing-account ${GCP_BILLING_ACCOUNT_ID}

    # Permissions and Credentials:
    # Now that we have a linked project, we have a few chores below:
    #  - Create service account and download service account credentials
    #  - Grant permissions to manage projects and GCS bucket (which will be used later to store Terraform state)
    #  - Grant permissions to service account (requires organization) associated with Admin project

    echo -e "🚪 create service account in Terraform Admin Project 🚪"
    echo -e "🚪 {{root}} {{bold}}gcloud iam service-accounts create cloudseed-terraform-admin --display-name 'Cloudseed Terraform Admin Account' {{normal}}🚪 "; \
    gcloud iam service-accounts create cloudseed-terraform-admin --display-name 'Cloudseed Terraform Admin Account'

    echo -e "🚪 grant service account permission to view Admin Project & Manage Cloud Storage 🚪"
    for ROLE in 'viewer' 'storage.admin'; do
        gcloud projects add-iam-policy-binding ${TERRAFORM_PROJECT_NAME} \
        --member serviceAccount:${TERRAFORM_ADMIN_ACCOUNT} \
        --role roles/${ROLE}
    done

    echo -e "🚪 Enable APIs for cloudseed-terraform-admin 🚪"
    for API in 'cloudresourcemanager' 'cloudbilling' 'iam' 'compute' 'cloudkms' 'servicenetworking' 'sqladmin' 'appengine' 'cloudresourcemanager'; do
        gcloud services enable "${API}.googleapis.com"
    done

    echo -e "🚪 Grant service account permissions to create projects & assign billing accounts 🚪"
    for ROLE in 'resourcemanager.projectCreator' 'billing.user' 'cloudkms.admin'; do
        gcloud organizations add-iam-policy-binding ${GCP_ORGANIZATION_ID} \
            --member serviceAccount:${TERRAFORM_ADMIN_ACCOUNT} \
            --role roles/${ROLE}
    done

    echo -e "🚪 Create the remote backend bucket 🚪"
    gsutil mb -p ${TERRAFORM_PROJECT_NAME} gs://${TERRAFORM_PROJECT_NAME}

    echo -e "🚪 Enable versioning for remote bucket 🚪"
    gsutil versioning set on gs://${TERRAFORM_PROJECT_NAME}

    echo -e "🚪 download JSON credentials to: ${GOOGLE_APPLICATION_CREDENTIALS} 🚪"
    echo -e "🚪 {{root}} {{bold}}gcloud iam service-accounts keys create ${GOOGLE_APPLICATION_CREDENTIALS} --iam-account ${TERRAFORM_ADMIN_ACCOUNT} {{normal}}🚪 "; \
    gcloud iam service-accounts keys create ${GOOGLE_APPLICATION_CREDENTIALS} --iam-account ${TERRAFORM_ADMIN_ACCOUNT}
    # After this we no longer need the root account to be active, all other operations use the above credential mapped to the terraform service account

    #############################################################################################################################
    # Now switch to the service account and set up sops encryption
    # The new terraform admin project uses sops for encrypting values: create the KMS key + key ring
    #############################################################################################################################
    deno run --unstable --allow-all ${CLOUDSEED_DENO_ROOT}/cloudseed/gcp/gcloud_init_sops.ts

    #############################################################################################################################
    # Keep a record of the billing account and organization to automate creating new projects
    #############################################################################################################################
    cat << EOF | jq . > $GOOGLE_ORGANIZATION_JSON
    {
        "organization_id": "${GCP_ORGANIZATION_ID}",
        "billing_account": "${GCP_BILLING_ACCOUNT_ID}",
        "owner_email": "${ROOT_OWNER_EMAIL}"
    }
    EOF
    just encrypt $GOOGLE_ORGANIZATION_JSON

# 🌱 sops encrypt using the GCE KMS key (consumes $GOOGLE_APPLICATION_CREDENTIALS) https://github.com/mozilla/sops
@encrypt file: activate_service_account
    sops --encrypt --gcp-kms $(just _sops_key) --in-place {{file}}

# 🌱 sops decrypt using the GCE KMS key (consumes $GOOGLE_APPLICATION_CREDENTIALS)
@decrypt file: activate_service_account
    sops --decrypt {{file}}

# Recreate a key (credentials/terraform-admin.json) for the cloudseed terraform admin service account (if none exists). Used by CI systems (Github Actions, CircleCI). Do not commit this file
service_account_key_recreate: root_account_authenticate
    #!/usr/bin/env bash
    if [ -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
        echo -e "🚪 👍 already exists: {{bold}}$GOOGLE_APPLICATION_CREDENTIALS{{normal}}"
        echo -e "🚪 ➡ I will never automatically overwrite this. Delete the key if you want to recreate 🚪"
        exit 0
    fi
    # exit when any command fails
    set -euo pipefail
    export TERRAFORM_PROJECT_NAME=$(just _terraform_project_id)
    # e.g. cloudseed-terraform-admin@metapages_cloudseed.iam.gserviceaccount.com
    export TERRAFORM_ADMIN_ACCOUNT=$(just _terraform_project_service_account)
    echo -e "🚪 download JSON credentials to: ${GOOGLE_APPLICATION_CREDENTIALS} 🚪"
    echo -e "🚪 {{root}} {{bold}}gcloud iam service-accounts keys create ${GOOGLE_APPLICATION_CREDENTIALS} --iam-account ${TERRAFORM_ADMIN_ACCOUNT} {{normal}}🚪 "
    gcloud iam service-accounts keys create ${GOOGLE_APPLICATION_CREDENTIALS} --iam-account ${TERRAFORM_ADMIN_ACCOUNT}
    echo "🚪  Copy {{GOOGLE_APPLICATION_CREDENTIALS}} to a secure location (encrypted keystore), you will need it for automated CI operations 🚪 "

# List keys for the cloudseed terraform admin service account
service_account_keys:
    #!/usr/bin/env bash
    set -euo pipefail
    export TERRAFORM_ADMIN_ACCOUNT=$(just _terraform_project_service_account)
    echo -e "🚪 {{root}} {{bold}}gcloud iam service-accounts keys list --format json --iam-account ${TERRAFORM_ADMIN_ACCOUNT} {{normal}}🚪 "
    gcloud iam service-accounts keys list --format json --iam-account ${TERRAFORM_ADMIN_ACCOUNT}

# Activate the root account (that creates and configures the service account). You shouldn't need unless you're debugging or testing
@root_account_authenticate:
    deno run --unstable --allow-all $ROOT/.cloudseed/deno/cloudseed/gcp/gcloud_auth_root_account_if_required.ts

# Activate the account used to perform deployments https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account
@activate_service_account: _terraform_project_service_account_key_required
    deno run --unstable --allow-all ${CLOUDSEED_DENO_ROOT}/cloudseed/gcp/gcloud_auth_service_account_if_required.ts

# project id from the credentials file
@_terraform_project_id: _terraform_project_service_account_key_required
    cat ${GOOGLE_APPLICATION_CREDENTIALS} | jq -r .project_id

# The full name of the cloudseed terraform service account
@_terraform_project_service_account: _terraform_project_service_account_key_required
    cat ${GOOGLE_APPLICATION_CREDENTIALS} | jq -r .client_email

# Check if the cloudseed terraform service account key file exists
@_terraform_project_service_account_key_required:
    if [ ! -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then \
        echo -e "🔥🚪 missing: {{bold}}$GOOGLE_APPLICATION_CREDENTIALS{{normal}} 🚪"; \
        echo -e "🔥🚪 ➡ Have you run: 'just $PWD/initialize'? 🚪"; \
        echo -e "🔥🚪 ➡ If the cloudseed-terraform-admin account is already created, do you need to recreate the key: 'just service_account_key_recreate' ? 🚪"; \
        exit 1; \
    fi

# Name of KMS key used by the cloudseed terraform admin service account to encrypt deployment secrets
@_sops_key:
    echo "projects/$(just _terraform_project_id)/locations/global/keyRings/sops/cryptoKeys/sops-key"
