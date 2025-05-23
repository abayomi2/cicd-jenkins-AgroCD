# cicd-jenkins-AgroCD
git pull --rebase origin main

# After setting up your cluster run the command to create namespace and ArgoCD Application resources:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Check the pods and Wait until all pods (especially argocd-server, argocd-repo-server, etc.) show as Running.
kubectl get pods -n argocd

# Then port-forward:
kubectl port-forward svc/argocd-server -n argocd 8080:443

# And access it at:
https://localhost:8080

# Get the ArgoCD Admin Password: The default login username is (admin). To get the password run:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo

# Steps to Expose ArgoCD via Ingress
# Run to Install ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/cloud/deploy.yaml

# Patch the ArgoCD server to use ClusterIP (if not already)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "ClusterIP"}}'

# Apply your argocd-app.yaml to ensure ArgoCD monitors deploys your applications in your manifests
kubectl apply -f argocd/argocd-app.yaml
kubectl -n argocd describe app cicd-app

# To use ingress controller for your application create a app-ingress.yaml and apply it
# Ensure to edit the svc cicd-app and change the service type from LoadBalancer to ClusterIP
