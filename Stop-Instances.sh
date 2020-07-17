# Variables
projectId='aisarch-test-project'
body='{"instances":"instance-2,instance-3","zone":"europe-north1-a"}' #Instance names comma separated
schedule='0 18 * * *' #https://crontab.guru/#0_18_*_*_*
timeZone='Europe/London'

# Auth to project
gcloud config set project $projectId

# Creating the Service Account
gcloud iam service-accounts create compute-instance-admin-sa \
  --description="Service account with computeinstanceadmin role" \
  --display-name="compute-instance-admin-sa"

# Assign the computeInstanceAdmin role to the service account
gcloud projects add-iam-policy-binding $projectId \
  --role roles/compute.instanceAdmin \
  --member serviceAccount:compute-instance-admin-sa@$projectId.iam.gserviceaccount.com

# Creating the Pub/Sub Topics
gcloud pubsub topics create stop-instances

# Creating Cloud Functions
git clone https://github.com/bbz94/Stop-GCPInstances
dirPath=$(readlink -f Stop-GCPInstances)

# Deploy the Start Cloud function
gcloud functions deploy stop-instances-fun  \
--trigger-topic=stop-instances \
--region=europe-west1 \
--ingress-settings=internal-only \
--service-account=compute-instance-admin-sa@$projectId.iam.gserviceaccount.com \
--source=$dirPath \
--runtime=nodejs10 \
--quiet

# Setting up the Cloud Scheduler
gcloud scheduler jobs create pubsub stop-instances-on-sob \
    --schedule "$schedule" \
    --topic stop-instances \
    --message-body $body \
    --time-zone $timeZone