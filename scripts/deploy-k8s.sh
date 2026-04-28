#!/bin/bash

# Kubernetes Deployment Script
# Applies all Kubernetes manifests to the cluster

set -e

echo "☸️  Starting Kubernetes Deployment..."

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

# Check cluster connection
echo "🔗 Checking cluster connection..."
kubectl cluster-info || {
    echo "❌ Cannot connect to Kubernetes cluster. Start minikube/k3s first."
    exit 1
}

# Create namespace
echo "📦 Creating namespace..."
kubectl create namespace devops-app --dry-run=client -o yaml | kubectl apply -f -

# Apply manifests
echo "🚀 Deploying applications..."
kubectl apply -f k8s/

# Show deployment status
echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Checking pod status..."
kubectl get pods -n default

echo ""
echo "🔗 Checking services..."
kubectl get services -n default

echo ""
echo "💡 Useful commands:"
echo "   kubectl get pods"
echo "   kubectl get services"
echo "   kubectl logs <pod-name>"
echo "   kubectl describe pod <pod-name>"
