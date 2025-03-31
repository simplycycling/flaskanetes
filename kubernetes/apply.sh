#!/bin/bash

# Set environment variables
export AWS_ACCOUNT_ID=650251696513
export AWS_REGION=ap-southeast-2
export KUBERNETES_NAMESPACE=flaskanetes

# Create namespace if it doesn't exist
kubectl create namespace $KUBERNETES_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Process and apply manifests
for file in base/*.yaml; do
    # Replace environment variables in the manifest
    envsubst < "$file" | kubectl apply -n $KUBERNETES_NAMESPACE -f -
done

# Wait for deployment to be ready
kubectl rollout status deployment/flaskanetes -n $KUBERNETES_NAMESPACE 