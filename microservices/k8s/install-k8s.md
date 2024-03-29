- [K8S 三大指令](#k8s-三大指令)
- [Reference](#reference)
- [建立 K8S Cluster](#建立-k8s-cluster)
    - [1. Master of Single](#1-master-of-single)
    - [2. 安裝 Dashborad](#2-安裝-dashborad)
    - [3. 檢查](#3-檢查)
    - [4. Masters of HA (option)](#4-masters-of-ha-option)
- [建立 Worker Node](#建立-worker-node)
- [部署 Container (try it!)](#部署-container-try-it)
- [Load Balancer for K8S (HA option)](#load-balancer-for-k8s-ha-option)

# K8S 三大指令
- kubeadm
    - K8S deploy 工具
    - the command to bootstrap the cluster
- kubelet
    - node 用來 master 溝通的內部元件
    - the component that runs on all of the machines in your cluster and does things like starting pods and containers
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
    - 控制 K8S
    - the command line util to talk to your cluster
    - `kubectl cluster-info`
    - `kubectl get pods`
    - `kubectl get service`
- helm
    - 實作部屬的工具

# Reference
- 安裝
    - [Steps for Installing Kubernetes on CentOS 7](https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos)
    - [CentOS 7.6 上安裝 Kubernetes（一）叢集佈署](https://blog.tomy168.com/2019/08/centos-76-kubernetes.html)
    - [CentOS 7.6上安裝 Kubernetes（二）監控儀表板](https://blog.tomy168.com/2020/03/centos-76-kubernetes.html)
    - [Kubernetes 安裝筆記](https://blog.johnwu.cc/article/kubernetes-exercise.html)
    - https://ithelp.ithome.com.tw/articles/10235069?sc=iThomeR
- 不錯的說明
    - [使用 kubeadm 安装 kubernetes 1.15.1](http://www.manongjc.com/detail/9-pbmajemrfahtfpl.html)
    - [實現 Kubernetes 高可靠架構部署](https://k2r2bai.com/2019/09/20/ironman2020/day05/)
    - [如何自建 K8S HA Cluster](https://brobridge.com/bdsres/2019/08/30/本篇目標是針對如何自學建立k8s架構/)
    - [How To Install Kubernetes Dashboard with NodePort](https://computingforgeeks.com/how-to-install-kubernetes-dashboard-with-nodeport/)
    - [Configuring HA Kubernetes cluster on bare metal servers](https://faun.pub/configuring-ha-kubernetes-cluster-on-bare-metal-servers-monitoring-logs-and-usage-examples-3-3-340357f21453)
    - https://github.com/cookeem/kubeadm-ha
- 網路
    - [常見 CNI (Container Network Interface) Plugin 介紹](https://www.hwchiu.com/cni-compare.html)

# 建立 K8S Cluster
## 1. Master of Single
- 使用 flannel CNI，如果沒有 CNI，請參考 [Kubernetes - Nodes NotReady](https://blog.johnwu.cc/article/kubernetes-nodes-notready.html)
    - `sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $(hostname -i)`
    - 如果 init 有問題，就重置它
        - `sudo kubeadm reset`
        - 都無解，就執行它
            - `kubeadm init`
        - 刪除 master / worker
            ```bash
            kubectl cordon t-k8s-n1
            kubectl drain t-k8s-n1 --ignore-daemonsets --force=true --delete-local-data=true
            kubectl delete node t-k8s-n1
            ```
- 設定 config
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    export KUBECONFIG=$HOME/.kube/config
    ```
- root env
    ```bash
    sudo export KUBECONFIG=/etc/kubernetes/admin.conf
    ```
- 如果 token 忘的話
    - `sudo kubeadm token create --print-join-command`
- 此時 node status 為 NotReady
- 設定 pod network (f: file, k: directory)
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`
- 此時 node status 為 Ready
- 檢查狀態
    - `kubectl -n kube-system get po -l app=flannel -o wide`
    - `kubectl get nodes`
    - `kubectl get pods --all-namespaces`
    - `kubectl cluster-info`

## 2. 安裝 Dashborad
[install-dashboard.md](./install-dashboard.md)

## 3. 檢查
- nodes 都要是 Ready，NotReady 解法: [移除 CNI 參數](https://blog.johnwu.cc/article/kubernetes-nodes-notready.html)
    - `kubectl get nodes`
    - `vi /var/lib/kubelet/kubeadm-flags.env`
        ```
        KUBELET_KUBEADM_ARGS="--pod-infra-container-image=k8s.gcr.io/pause:3.4.1"
        ```
    - `sudo systemctl daemon-reload`
    - `sudo systemctl restart kubelet.service`
- 集群都要是 Healthy，Unhealthy 解法: [修改 port 值](https://blog.csdn.net/xiaobao7865/article/details/107513957)
    - `kubectl get cs`
- 檢查 pods
    - `kubectl get pods -A`
- pods pending
    - `kubectl describe pods`

## 4. Masters of HA (option)
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
    - `sudo kubeadm init --config=kubeadm-config.yaml --upload-certs --ignore-preflight-errors=all`
    - 重新產生新的 key
        - `sudo kubeadm init phase upload-certs --experimental-upload-certs`
- 設定 pod network
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`
- 同步 config to load balancer
    - `sudo rsync -av t-k8s-m1:/etc/kubernetes/ /etc/kubernetes/`

# 建立 Worker Node
至兩台 node 輸入上一節 worker nodes 欲加入叢集所需輸入的指令，就是這麼簡單！
<br><img src="https://www.ovh.com/blog/wp-content/uploads/2019/03/IMG_0135.jpg" alt="drawing" width="500" board="1"/>

- 加入 cluster，該 token 24 小時以內才有效
    - `sudo kubeadm join 10.0.8.4:6443 --token XXXX --discovery-token-ca-cert-hash sha256:XXXX`
    - 失敗的話，請參考: https://stackoverflow.com/questions/55531834/kubeadm-fails-to-initialize-when-kubeadm-init-is-called
        - `sudo kubeadm reset`
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
        - `sudo kubeadm reset`

# 部署 Container (try it!)
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
    - `kubectl get services`、`kubectl get svc`
        ```
        NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
        kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        23m
        nginx        NodePort    10.103.227.82   <none>        80:32300/TCP   89s
        ```
- 顯示 container 服務: http://public-ip:32300
    <br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-container-example.png?raw=true">

# Load Balancer for K8S (HA option)
<br><img src="https://brobridge.com/bdsres/wp-content/uploads/2019/08/image-1024x769.png">

- 安裝 HAProxy
    - `sudo yum install haproxy -y`
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
    sudo systemctl enable haproxy
    sudo systemctl start haproxy
    ```
- 安裝 K8S
    ```bash
    cat << EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF

    sudo yum install kubectl -y
    ```