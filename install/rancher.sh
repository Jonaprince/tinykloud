#!/bin/bash

kubectl create namespace cattle-system

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Add rancher repositry
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.1
  --values values/cert-manager.yaml


helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.dev.ig2h \
  --set replicas=3
