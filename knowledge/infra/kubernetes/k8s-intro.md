# Kubernetes Introduction
K8S is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. K8S services, support, and tools are widely available.
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-architecture.png?raw=true" alt="drawing" width="800" board="1"/>
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-vs-app-diff.png?raw=true" alt="drawing" width="800" board="1"/>

## Know docker
差異就在: https://nakivo.medium.com/kubernetes-vs-docker-what-is-the-difference-3b0c6cce97d3

## 1. Kubernetes Architecture
### (1) Control Plane Components
- etcd
    <br>To store **configuration data** that can be accessed by each of the nodes in the cluster.
- kube-apiserver
    <br>This is the main management point of the entire cluster as it allows a user to configure Kubernetes’ workloads and organizational units.
- kube-controller-manager
- kube-scheduler
- cloud-controller-manager

### (2) Node Components
Node components run on every node, maintaining running pods and providing the K8S runtime environment.
- kubelet
- A Container Runtime
- kube-proxy

### (3) Kubernetes Objects and Workloads
- Pods
- Replication Controllers and Replication Sets
- Deployments
- Stateful Sets
- Daemon Sets
- Jobs and Cron Jobs

### (4) Other Kubernetes Components
- Services
- Volumes and Persistent Volumes
- Labels and Annotations
- DNS
- Web UI (Dashboard)
- Container Resource Monitoring
- Cluster-level Logging