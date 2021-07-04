- [Deploy dashboard](#deploy-dashboard)
- [Access dashboard](#access-dashboard)
- [Create a cluster admin service account](#create-a-cluster-admin-service-account)

# Deploy dashboard
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
```
- 確認狀態
    - `kubectl get svc --namespace=kube-system`
    - `kubectl get service -n kubernetes-dashboard`
- `wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml`
- `mv recommended.yaml kubernetes-dashboard-deployment.yml`
- `vi kubernetes-dashboard-deployment.yml`
    - add `type: NodePort`
- `kubectl apply -f kubernetes-dashboard-deployment.yml`

# Access dashboard
```bash
# It will proxy server between your machine and Kubernetes API server.
# Run all these commands in a new terminal, otherwise your kubectl proxy command will stop.
kubectl proxy &
```
- http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

# Create a cluster admin service account
```bash
# Create a service account for a dashboard in the default namespace.
kubectl create serviceaccount dashboard -n default

kubectl create clusterrolebinding dashboard-admin -n default \
--clusterrole=cluster-admin \
--serviceaccount=default:dashboard

# Copy the secret token required for your dashboard login.
kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
```