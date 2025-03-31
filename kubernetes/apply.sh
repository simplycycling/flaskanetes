#!/bin/bash

# Set environment variables
export AWS_ACCOUNT_ID=650251696513
export AWS_REGION=ap-southeast-2
export KUBERNETES_NAMESPACE=flaskanetes
export EKS_CLUSTER=flaskanetes-dev

# Update kubeconfig
echo "Updating kubeconfig..."
aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION

# Verify AWS credentials
echo "Verifying AWS credentials..."
aws sts get-caller-identity

# Create namespace if it doesn't exist
echo "Creating namespace $KUBERNETES_NAMESPACE..."
kubectl create namespace $KUBERNETES_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Process and apply manifests
echo "Applying Kubernetes manifests..."
for file in base/*.yaml; do
    echo "Processing $file..."
    # Replace environment variables in the manifest
    envsubst < "$file" | kubectl apply -n $KUBERNETES_NAMESPACE -f -
done

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/flaskanetes -n $KUBERNETES_NAMESPACE 