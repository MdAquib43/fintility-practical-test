#!/bin/bash
set -e

echo "=== Installing Kind if needed ==="

if ! command -v kind >/dev/null 2>&1; then
  curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
  chmod +x /tmp/kind
  sudo mv /tmp/kind /usr/local/bin/kind
fi

echo "=== Creating Kind cluster if needed ==="

if ! kind get clusters 2>/dev/null | grep -q "^fintility-cluster$"; then
  kind create cluster --name fintility-cluster
fi

kubectl config use-context kind-fintility-cluster

echo "=== Building Docker image ==="

docker build -t webserver:local .

echo "=== Loading image into Kind ==="

kind load docker-image webserver:local --name fintility-cluster

echo "=== Deploying Kubernetes manifests ==="

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "=== Waiting for deployment ==="

kubectl rollout status deployment/webserver-deployment --timeout=120s

echo "=== Kubernetes status ==="

kubectl get nodes
kubectl get pods
kubectl get deployment
kubectl get service

echo "=== Fintility environment is ready ==="