#!/bin/bash
pod=$(/google/google-cloud-sdk/bin/kubectl get po -n keycloak | grep postgres | awk '{print $1}')
gcloud container clusters get-credentials kube-dev --zone us-central1-a --project keycloak-test-230419
/google/google-cloud-sdk/bin/kubectl exec "$pod" -n keycloak -- pg_dump -U keycloak > /home/sai/backup/postgresql_"$(date +%d-%m-%Y"_"%H_%M_%S)".sql
/google/google-cloud-sdk/bin/gsutil cp /home/sai/backup/postgresql_* gs://backups-keycloak/Backups/
if [[ $? -eq 0 ]]; then
  echo "$(date +%d-%m-%Y"_"%H_%M_%S) Backup transfer successful" >> /home/sai/backup/backup.log
else
  echo "$(date +%d-%m-%Y"_"%H_%M_%S) Backup transfer failed" >> /home/sai/backup/backup.log
fi
rm -f postgresql_*
