#!/bin/bash

set -e

# Customize these
ARGOCD_NAMESPACE="argocd"
JENKINS_NAMESPACE="jenkins"
SONAR_NAMESPACE="sonarqube"
JFROG_NAMESPACE="jfrog"
APP_NAME="gitops-app"

echo "📦 Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "✅ Helm version: $(helm version --short)"

echo "🚀 Step 1: Installing ArgoCD..."
kubectl create namespace $ARGOCD_NAMESPACE || true
kubectl apply -n $ARGOCD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "⏳ Waiting for ArgoCD pods..."
kubectl wait --for=condition=Ready pods --all -n $ARGOCD_NAMESPACE --timeout=180s

echo "🔧 Applying ArgoCD Application manifest..."
kubectl apply -f argocd/argocd-app.yaml

echo "📦 Step 2: Installing Jenkins..."
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins --namespace $JENKINS_NAMESPACE --create-namespace \
  --set controller.serviceType=LoadBalancer \
  --set controller.admin.username=admin \
  --set controller.admin.password=admin123


echo "⏳ Waiting for Jenkins to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/component=jenkins-controller -n $JENKINS_NAMESPACE --timeout=300s

echo "📦 Step 3: Installing SonarQube..."
helm repo add oteemocharts https://oteemo.github.io/charts
helm repo update
helm install sonarqube oteemocharts/sonarqube --namespace $SONAR_NAMESPACE --create-namespace

echo "⏳ Waiting for SonarQube pods..."
kubectl wait --for=condition=Ready pod -l app=sonarqube -n $SONAR_NAMESPACE --timeout=300s

echo "📦 Step 4: Installing JFrog Artifactory OSS..."
helm repo add jfrog https://charts.jfrog.io
helm repo update
helm install artifactory jfrog/artifactory-oss --namespace $JFROG_NAMESPACE --create-namespace \
  --set artifactory.service.type=LoadBalancer

echo "⏳ Waiting for Artifactory to be ready..."
kubectl wait --for=condition=Ready pod -l app=artifactory -n $JFROG_NAMESPACE --timeout=300s

echo "🔍 Getting external service URLs..."
echo "ArgoCD:         https://localhost:8080"
echo "Jenkins:        $(kubectl get svc -n $JENKINS_NAMESPACE -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')"
echo "SonarQube:      $(kubectl get svc -n $SONAR_NAMESPACE -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')"
echo "Artifactory:    $(kubectl get svc -n $JFROG_NAMESPACE -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')"

echo "✅ ArgoCD admin password:"
kubectl -n $ARGOCD_NAMESPACE get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode; echo

echo "🎉 Setup complete!"
echo "👉 Visit ArgoCD, Jenkins, SonarQube, and Artifactory UIs to finish config & integrate with your Jenkinsfile pipeline."
