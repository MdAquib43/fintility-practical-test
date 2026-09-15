#!/bin/bash

# Install Kind if not installed
if ! command -v kind >/dev/null 2>&1; then
  curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
  chmod +x /tmp/kind
  sudo mv /tmp/kind /usr/local/bin/kind
fi

# Create Kind cluster if it doesn't exist
if ! kind get clusters 2>/dev/null | grep -q "^fintility-cluster$"; then
  kind create cluster --name fintility-cluster
fi

# Configure kubectl
kubectl config use-context kind-fintility-cluster

# Deploy application
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment
kubectl rollout status deployment/webserver-deployment --timeout=120s

echo "=================================="
echo "Fintility Kubernetes environment ready!"
echo "=================================="

kubectl get nodes
kubectl get pods
kubectl get service