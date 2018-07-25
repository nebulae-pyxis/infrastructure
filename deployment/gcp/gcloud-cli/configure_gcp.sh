#!/bin/bash

#activate gcloud
gcloud auth activate-service-account $GCP_SERVICE_ACCOUNT_ID --key-file=deployment/gcp/tokens/nebulae-pyxis-gcp-config.json

#Configure default project and Zone
gcloud config set project nebulae-pyxis
gcloud config set compute/zone  us-central1-a

# Create Kubernetes engine cluster and link kubectl
gcloud container clusters create kec-main
gcloud container clusters get-credentials kec-main

# Deploy secrets
kubectl create -f deployment/gcp/secrets/secret-keycloak.yml
kubectl create -f deployment/gcp/secrets/secret-apollo.yml
kubectl create secret generic google-application-credentials --from-file=deployment/gcp/tokens/gcloud-service-key.json


# Deploy ingress 
# KEYCLOAK, EMI AND API_GATEWAY MUST BE DEPLOYED!!!
kubectl apply -f deployment/gcp/kubernetes_configs/ingress-web-main.yml

