# AKS Doc
- [Cloud-native applications](https://github.com/Microsoft-CloudRiches/MCW-Cloud-native-applications)
- code 說明
    - M: MCW-Cloud-native-applications/Hands-on lab/lab-files/infrastructure/content-init
    - V: MCW-Cloud-native-applications/Hands-on lab/lab-files/infrastructure/content-web
    - C: MCW-Cloud-native-applications/Hands-on lab/lab-files/infrastructure/content-api

# Create a private Azure Kubernetes Service cluster
In a private cluster, the control plane or API server has **internal IP addresses** that are defined in the RFC1918 - Address Allocation for Private Internet document. By using a private cluster, you can ensure network traffic between your API server and your node pools remains on the private network only.

The control plane or API server is in an AKS-managed Azure subscription. A customer's cluster or node pool is in the customer's subscription. The server and the cluster or node pool can communicate with each other through the Azure Private Link service in the API server virtual network and a private endpoint that's exposed in the subnet of the customer's AKS cluster.

# 上課筆記 (AZ303)
```bash
resource_group="RG-Day5"
location="southeastasia"
az aks create --resource-group $resource_group --name az990820-akscluster --node-count 1 --node-vm-size standard_d2s_v3 --generate-ssh-key
kubectl get nodes
az get-credentials -r $resource_group -n az990820-akscluster
az aks get-credentials -g $resource_group -n az990820-akscluster
kubectl get nodes
kubectl create deployment az990820-akscluster --image=nginx --replicas=1 --port=80
kubectl get pods
kubectl get svc --watch
kubectl expose deployment az990820-akscluster --port=80 --type=LoadBalancer
kubectl get svc
kubectl scale --replicas=2 deployment/az990820-akscluster
kubectl get svc
kubectl get pods
kubectl get nodes
history
```