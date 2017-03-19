#!/bin/bash

# Exit on any error
set -e

RAILS_ENV=production bundle exec rails db:migrate
sudo /opt/google-cloud-sdk/bin/gcloud docker -- push us.gcr.io/${PROJECT_NAME}/rku
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
# Update deployment file with environment values
envsubst < deployment.yml > deployment.parsed.yml
# Applies the rolling update to the deployment
kubectl patch -f deployment.yml -p "`cat deployment.parsed.yml`"
