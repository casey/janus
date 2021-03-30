remote_folder := 'gs://dm-demo-data/code'
jar_name := 'datamechanics-demo-assembly-0.1.0-SNAPSHOT.jar'
cluster_url := 'https://demo.datamechanics.co'
api_key := 'null'

# Run JAR locally
run_spark_pi_locally +arg='10':
    sbt "runMain co.datamechanics.pi.LocalMain {{arg}}"

# Build the JAR and push it to GCS
update_jar:
    sbt assembly
    gsutil cp target/scala-2.12/{{jar_name}} {{remote_folder}}/{{jar_name}}

# Run JAR on Data Mechanics
run_spark_pi_on_cluster +arg='100':
    #!/bin/bash
    output=$(curl -s --request POST {{cluster_url}}/api/apps/ \
        --header 'Content-Type: application/json' \
        --header 'X-API-Key: {{api_key}}' \
        --data-raw '{
          "jobName": "scala-spark-pi",
          "configOverrides": {
            "type": "Scala",
            "sparkVersion": "3.0.1",
            "image": "gcr.io/datamechanics/spark-connectors:3.0-latest",
            "mainApplicationFile": "{{remote_folder}}/{{jar_name}}",
            "mainClass": "co.datamechanics.pi.Main",
            "arguments": ["{{arg}}"]
          }
        }')
    echo $output | jq -r
    app_name=$(echo $output | jq -r '.appName')
    echo "Check out the app at {{cluster_url}}/dashboard/apps/$app_name"
    just api_key={{api_key}} cluster_url={{cluster_url}} _stream_logs $app_name

# Get the status of an app
_get_app_state app_name:
    @curl -s --request GET {{cluster_url}}/api/apps/{{app_name}} \
        --header 'Content-Type: application/json' \
        --header 'X-API-Key: {{api_key}}' | jq -r '.status.state'

# Print the live driver log stream of an app
_stream_logs app_name:
    #!/bin/bash
    app_state="null"
    echo {{app_name}}
    while [ "$app_state" = "null" -o "$app_state" = "SUBMITTED" -o "$app_state" = "" ]
    do
        app_state=$(just api_key={{api_key}} cluster_url={{cluster_url}} _get_app_state {{app_name}})
        echo "App is in state $app_state, waiting..."
        sleep 1
    done
    curl --request GET {{cluster_url}}/api/apps/{{app_name}}/live/driver-log \
        --header 'Content-Type: application/json' \
        --header 'X-API-Key: {{api_key}}'
