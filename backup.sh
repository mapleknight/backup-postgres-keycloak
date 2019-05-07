#!/bin/bash
gcloud container clusters get-credentials kube-dev --zone us-central1-a --project keycloak-test-230419
kubectl exec -it $(kubectl get po -n keycloak | grep postgres | awk '{print $1}') -n keycloak -- pg_dump -U keycloak > postgresql_$(date +%d-%m-%Y"_"%H_%M_%S).sql
gsutil cp postgresql_* gs://backups-keycloak/Backups/
if [[ $? -eq 0 ]]; then
  echo "$(date +%d-%m-%Y"_"%H_%M_%S) Backup transfer successful" >> backup.log
else
  echo "$(date +%d-%m-%Y"_"%H_%M_%S) Backup transfer failed" >> backup.log
fi
rm -f postgresql_*
