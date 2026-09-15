#!/bin/bash

if ! command -v kind >/dev/null 2>&1; then
  curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
  chmod +x /tmp/kind
  sudo mv /tmp/kind /usr/local/bin/kind
fi

if ! kind get clusters 2>/dev/null | grep -q "^fintility-cluster$"; then
  kind create cluster --name fintility-cluster
fi

kubectl config use-context kind-fintility-cluster
