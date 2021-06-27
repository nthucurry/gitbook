# Kubernetes Introduction
K8S is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. K8S services, support, and tools are widely available.
- 同時部署多個容器 (container) 到多台機器 (node) 上 (deployment)
- 服務的乘載量有變化時，可以對容器做自動擴展 (scaling)
- 管理多個容器的狀態，自動偵測並重啟故障的容器 (management)
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-architecture.png?raw=true" alt="drawing" width="800" board="1"/>
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-vs-app-diff.png?raw=true" alt="drawing" width="800" board="1"/>

## Know docker
差異就在: https://nakivo.medium.com/kubernetes-vs-docker-what-is-the-difference-3b0c6cce97d3

## 1. Kubernetes Architecture
### (1) Control Plane
K8S 運作的指揮中心，可以簡化看成一個特化的 node，負責管理所有其他 node
- etcd
    - To store **configuration data** that can be accessed by each of the nodes in the cluster.
    - 用來存放 K8S Cluster 的資料作為備份，當 Master 因為某些原因而故障時，我們可以透過 etcd 幫我們還原 K8S 的狀態
- kube-apiserver
    - This is the main management point of the entire cluster as it allows a user to configure Kubernetes’ workloads and organizational units.
    - 管理整個 K8S 所需 API 的接口 (endpoint)，例如從 command line 下 kubectl 指令就會把指令送到這裡
    - 負責 node 之間的溝通橋樑，每個 node 彼此不能直接溝通，必須要透過 apiserver 轉介
    - 負責 K8S 中的請求的身份認證與授權
- kube-controller-manager
    - 負責管理並運行 K8S controller 的組件，簡單來說 controller 就是 K8S 裡一個個負責監視 cluster 狀態的 process，例如：node controller、replication controller
    - 這些 process 會在 cluster 與預期狀態 (desire state) 不符時嘗試更新現有狀態。
        <br>例如：現在要多開一台機器以應付突然增加的流量，那我的預期狀態就會更新成 n+1，現有狀態為 n，這時相對應的 controller 就會想辦法多開一台機器
    - controller-manager 的監視與嘗試更新也都需要透過訪問 kube-apiserver 達成
- kube-scheduler
    - 整個 K8S 的 pods 調度員，scheduler 會監視新建立但還沒有被指定要跑在哪個 node 上的 pod，並根據每個 node 上面資源規定、硬體限制等條件去協調出一個最適合放置的 node 讓該 pod 跑
- cloud-controller-manager

### (2) Worker Node (K8S 運作的最小硬體單位)
Node components run on every node, maintaining running pods and providing the K8S runtime environment.
- kubelet
    <br>為 node 的管理員，負責管理該 node 上的所有 pods 的狀態並負責與 master 溝通
- kube-proxy
    <br>為 node 的傳訊員，負責更新 node 的 iptables，讓 K8S 中不在該 node 的其他物件可以得知該 node 上所有 pods 的最新狀態
- Container Runtime
    <br>為 node 負責容器執行的程式，以 docker 容器為例就是 docker engine

### (3) Kubernetes Objects and Workloads
- Pods
    - 對應一個應用服務
    - 對應一個身分證 (yaml)
    - 對應一個容器，或多個
    - 共享網路資源 (local port)
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

## 簡易架構
<br><img src="https://miro.medium.com/max/4800/0*5N7SlevIHOdKB-yC">