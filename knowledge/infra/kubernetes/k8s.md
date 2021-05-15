# Kubernetes
K8S is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. K8S services, support, and tools are widely available.
- kubelet: node 用來 master 溝通的內部元件
- kubectl: 控制 K8S
    - `kubectl cluster-info`
    - `kubectl get pods`
    - `kubectl get service`
- helm: 實作部屬的工具
- kubeadm K8S deploy 工具

## Reference
- [Steps for Installing Kubernetes on CentOS 7](https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos)
- https://blog.tomy168.com/2019/08/centos-76-kubernetes.html
- https://blog.johnwu.cc/article/kubernetes-exercise.html
- https://ithelp.ithome.com.tw/articles/10235069?sc=iThomeR
- 不錯的說明
    - [使用kubeadm 安装 kubernetes 1.15.1](http://www.manongjc.com/detail/9-pbmajemrfahtfpl.html)
    - [實現 Kubernetes 高可靠架構部署](https://k2r2bai.com/2019/09/20/ironman2020/day05/)
    - [如何自建 K8S HA Cluster](https://brobridge.com/bdsres/2019/08/30/本篇目標是針對如何自學建立k8s架構/)
    - [How To Install Kubernetes Dashboard with NodePort](https://computingforgeeks.com/how-to-install-kubernetes-dashboard-with-nodeport/)
    - [Configuring HA Kubernetes cluster on bare metal servers](https://faun.pub/configuring-ha-kubernetes-cluster-on-bare-metal-servers-monitoring-logs-and-usage-examples-3-3-340357f21453)
    - https://github.com/cookeem/kubeadm-ha

## Information
一個可以幫助我們管理 microservices 的系統，他可以自動化地部署及管理多台機器上的多個 container。K8S 想解決的問題是：「手動部署多個容器到多台機器上並監測管理這些容器的狀態非常麻煩。」而 K8S 要提供的解法： 提供一個平台以較高層次的抽象化去自動化操作與管理容器們。
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-architecture.png?raw=true" alt="drawing" width="800" board="1"/>
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-vs-app-diff.png?raw=true" alt="drawing" width="800" board="1"/>

## Know docker
差異就在: https://nakivo.medium.com/kubernetes-vs-docker-what-is-the-difference-3b0c6cce97d3

## Sample
| type     | IP       | hostname |
|----------|----------|----------|
| k8s vip  | 10.0.8.4 | t-k8s-lb |
| master 1 | 10.0.8.5 | t-k8s-m1 |
| master 1 | 10.0.8.6 | t-k8s-m2 |
| worker 1 | 10.0.8.7 | t-k8s-n1 |
| worker 2 | 10.0.8.8 | t-k8s-n2 |

## Load Balancer for K8S (HA option)
<br><img src="https://brobridge.com/bdsres/wp-content/uploads/2019/08/image-1024x769.png">

- 安裝 HAProxy
    - `yum install haproxy -y`
- 設定 config
    ```bash
    cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
    cat >> /etc/haproxy/haproxy.cfg <<END
    frontend kubernetes
        bind t-k8s-lb:6443
        option tcplog
        mode tcp
        default_backend kubernetes-master-nodes
    backend kubernetes-master-nodes
        mode tcp
        balance roundrobin
        option tcp-check
        server t-k8s-m1 10.0.8.8:6443 check fall 3 rise 2
        server t-k8s-m2 10.0.8.9:6443 check fall 3 rise 2
    END
    ```
- 啟動
    ```bash
    systemctl enable haproxy
    systemctl start haproxy
    ```
- 安裝 K8S
    ```bash
    cat << EOF | tee /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF

    yum install kubectl -y
    ```
- 安裝 dashborad
    - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml`
    - `wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml`
    - `mv recommended.yaml kubernetes-dashboard-deployment.yml`
    - `vi kubernetes-dashboard-deployment.yml`
    - add `type: NodePort`

## Master
### 一、Master of Single VM
#### (1) 安裝 kubeadm
- 預先找出 kubeadmin 需要的 images (option, check internet connection)
    - `sudo kubeadm config images pull`
- 使用 flannel CNI，如果沒有 CNI，請參考 [Kubernetes - Nodes NotReady](https://blog.johnwu.cc/article/kubernetes-nodes-notready.html)
    - `sudo kubeadm init --pod-network-cidr=10.244.0.0/16`(~ 4 min)
    - 如果 init 有問題，就重置它
        - `kubeadm reset`
        - 都無解，就執行它
            - `kubeadm init`
        - 刪除 master / worker
            ```bash
            kubectl cordon t-k8s-n1
            kubectl drain t-k8s-n1 --ignore-daemonsets --force=true --delete-local-data=true
            kubectl delete node t-k8s-n1
            ```
- 設定 config
    - manage cluster as regular user
        ```bash
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        export KUBECONFIG=$HOME/.kube/config
        ```
    - root env
        ```bash
        sudo su
        export KUBECONFIG=/etc/kubernetes/admin.conf
        ```
- 定義 flannel config (f: file, k: directory)
    - `sudo su`
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`

#### (2) 安裝 Pod network add-on (添加物)
- 定義 flannel config (option)
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml`
- 確認 nodes 狀態
    - `kubectl get pods --all-namespaces`

#### (3) 驗證 kubectl configuration
- cluster 狀態，用 not-root
    - `kubectl cluster-info`
        ```
        Kubernetes control plane is running at https://10.0.8.4:6443
        KubeDNS is running at https://10.0.8.4:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
        ```

#### (4) 安裝 K8S Portal
- `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml`
- `kubectl proxy`
- 確認安裝狀態
    - `kubectl get deployment -n kube-system | grep dashboard`

#### (5) 檢查
- nodes 都要是 Ready，NotReady 解法: [移除 CNI 參數](https://blog.johnwu.cc/article/kubernetes-nodes-notready.html)
    - `kubectl get nodes`
- 集群都要是 Healthy，Unhealthy 解法: [修改 port 值](https://blog.csdn.net/xiaobao7865/article/details/107513957)
    - `kubectl get cs`
- 檢查 pods
    - `kubectl get pods -A`
- pods pending
    - `kubectl describe pods`

### 二、Masters of HA (option)
- 設定 config on master1
    ```bash
    cat > kubeadm-config.yaml << END
    apiVersion: kubeadm.k8s.io/v1beta1
    kind: ClusterConfiguration
    kubernetesVersion: stable
    controlPlaneEndpoint: "t-k8s-lb:6443"
    networking:
      podSubnet: "10.244.0.0/16"
    END
    ```
- kubeadmin join
    - `kubeadm init --config=kubeadm-config.yaml --upload-certs --ignore-preflight-errors=all`
    - 重新產生新的 key
        - `kubeadm init phase upload-certs --experimental-upload-certs`
- 加入 cluster
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`
- 同步 config to load balancer
    - `rsync -av t-k8s-m1:/etc/kubernetes/ /etc/kubernetes/`

## Node
至兩台 node 輸入上一節 worker nodes 欲加入叢集所需輸入的指令，就是這麼簡單！
<br><img src="https://www.ovh.com/blog/wp-content/uploads/2019/03/IMG_0135.jpg" alt="drawing" width="800" board="1"/>

- 加入 cluster，該 token 24 小時以內才有效
    - `kubeadm join 10.0.8.4:6443 --token XXXX --discovery-token-ca-cert-hash sha256:XXXX`
    - 失敗的話，請參考: https://stackoverflow.com/questions/55531834/kubeadm-fails-to-initialize-when-kubeadm-init-is-called
        - `kubeadm reset`
        - `echo 1 > /proc/sys/net/ipv4/ip_forward`
        - `--ignore-preflight-errors=all`
- 當 OS 重開後
    - token 會過期，重新產生: `kubeadm token create`
    - the value of --discovery-token-ca-cert-hash
        ```bash
        openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
        openssl dgst -sha256 -hex | sed 's/^.* //'
        ```
    - `kubectl config delete-cluster`
    - 將有關 K8S 的東西刪除
        - `kubeadm reset`

## 部署 Container (try it!)
- 部署名為 nginx 的容器，映像檔名稱為 nginx，透過參數 deployment 會自動幫你創建好 k8s 中的最小管理邏輯單位 pod 與容器
    - `kubectl create deployment nginx --image=nginx`
    - 如果 ContainerCreating 太久，先停掉 service 再重新執行一次
        - `kubectl delete pod nginx-6799fc88d8-h2m6h`
- 替容器建立一個 port mapping 的 service，讓 nginx 服務可以被外部存取
    - `kubectl create service nodeport nginx --tcp=80:80`
- 查詢 service mapping 的情況
    - `kubectl get pods`
        ```
        READY   STATUS    RESTARTS   AGE
        nginx-6799fc88d8-4bkb8   1/1     Running   0          3m36s
        ```
    - `kubectl get services`
        ```
        NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
        kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        23m
        nginx        NodePort    10.103.227.82   <none>        80:32300/TCP   89s
        ```
- 顯示 container 服務: http://public-ip:31550
    <br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-container-example.png?raw=true">