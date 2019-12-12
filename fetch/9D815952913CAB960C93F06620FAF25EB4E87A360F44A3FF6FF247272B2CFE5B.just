token:
  sed -i "" "s/GCLOUD_.*/GCLOUD_TOKEN=`gcloud auth print-access-token`/" ./.env