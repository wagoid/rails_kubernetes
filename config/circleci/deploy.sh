# Exit on any error
set -e

# prepare database before running containers
git checkout config/database.yml
RAILS_ENV=production bundle exec rails db:migrate
# Update deployment file with environment values
RAILS_ENV=production envsubst < deployment.yml > deployment.parsed.yml

sudo /opt/google-cloud-sdk/bin/gcloud docker -- push gcr.io/${PROJECT_NAME}/rku
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
# Applies the rolling update to the deployment
GOOGLE_APPLICATION_CREDENTIALS=../account-auth.json kubectl patch --record -f deployment.yml -p "`cat deployment.parsed.yml`"
