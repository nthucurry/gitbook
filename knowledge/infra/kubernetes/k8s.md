# Kubernetes
<img src="https://d33wubrfki0l68.cloudfront.net/26a177ede4d7b032362289c6fccd448fc4a91174/eb693/images/docs/container_evolution.svg" alt="drawing" width="800" board="1"/><br>
K8S is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. K8S services, support, and tools are widely available.
- kubelet: node 用來 master 溝通的內部元件
- kubectl: 開發者用來控制
- helm: 實作部屬的工具
- kubeadm K8S 部屬工具

## Reference
- [Installing Docker on CentOS 7 With Yum](https://phoenixnap.com/kb/how-to-install-docker-centos-7)
- [Steps for Installing Kubernetes on CentOS 7](https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos)
- https://blog.tomy168.com/2019/08/centos-76-kubernetes.html
- https://blog.johnwu.cc/article/kubernetes-exercise.html
- https://ithelp.ithome.com.tw/articles/10235069?sc=iThomeR
- http://www.manongjc.com/detail/9-pbmajemrfahtfpl.html

## Information
一個可以幫助我們管理 microservices 的系統，他可以自動化地部署及管理多台機器上的多個 container。K8S 想解決的問題是：「手動部署多個容器到多台機器上並監測管理這些容器的狀態非常麻煩。」而 K8S 要提供的解法： 提供一個平台以較高層次的抽象化去自動化操作與管理容器們。
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-architecture.png?raw=true" alt="drawing" width="800" board="1"/>
<br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-vs-app-diff.png?raw=true" alt="drawing" width="800" board="1"/>

## Know docker
差異就在: https://nakivo.medium.com/kubernetes-vs-docker-what-is-the-difference-3b0c6cce97d3

## Master
### 一、Master of Single VM
#### (1) 安裝 kubeadm
- 找出 kubeadmin 需要的 images (option)
    - `sudo kubeadm config images pull`
- 使用 flannel CNI
    - `sudo kubeadm init --pod-network-cidr=10.244.0.0/16`(~ 4 min)
        ```txt
        [init] Using Kubernetes version: v1.21.0
        [preflight] Running pre-flight checks
        [preflight] Pulling images required for setting up a Kubernetes cluster
        [preflight] This might take a minute or two, depending on the speed of your internet connection
        [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
        ...
        ```
- 設定 config
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    export KUBECONFIG=$HOME/.kube/config
    ```
    ```bash
    sudo su
    export KUBECONFIG=/etc/kubernetes/admin.conf
    ```
- 定義 flannel config (f: file, k: directory)
    - `sudo su`
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`
        ```txt
        podsecuritypolicy.policy/psp.flannel.unprivileged created
        clusterrole.rbac.authorization.k8s.io/flannel created
        clusterrolebinding.rbac.authorization.k8s.io/flannel created
        serviceaccount/flannel created
        configmap/kube-flannel-cfg created
        daemonset.apps/kube-flannel-ds created
        ```
- 確認 nodes 狀態 (not-root)
    - `kubectl get nodes`
        ```txt
        NAME              STATUS   ROLES                  AGE    VERSION
        vm-t-k8s-master   Ready    control-plane,master   3d1h   v1.20.4
        vm-t-k8s-node1    Ready    <none>                 3d1h   v1.20.4
        vm-t-k8s-node2    Ready    <none>                 3d     v1.20.4
        ```
     如果 NotReady

- 安裝 Dashboard
    - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml`

#### (2) 安裝 Pod network add-on (添加物)
- 定義 flannel config (option)
    - `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml`
- 確認 nodes 狀態
    - `kubectl get pods --all-namespaces`
    ```txt
    NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
    kube-system   coredns-74ff55c5b-5zbrf                   1/1     Running   0          6m43s
    kube-system   coredns-74ff55c5b-92k2z                   1/1     Running   0          6m43s
    kube-system   etcd-vm-t-k8s-master                      1/1     Running   0          7m
    kube-system   kube-apiserver-vm-t-k8s-master            1/1     Running   0          7m
    kube-system   kube-controller-manager-vm-t-k8s-master   1/1     Running   0          7m
    kube-system   kube-flannel-ds-sqw42                     1/1     Running   0          2m3s
    kube-system   kube-proxy-hjkxk                          1/1     Running   0          6m44s
    kube-system   kube-scheduler-vm-t-k8s-master            1/1     Running   0          6m59s
    ```

#### (3) 驗證 kubectl configuration
- cluster 狀態，用 not-root
    - `kubectl cluster-info`
    ```txt
    Kubernetes control plane is running at https://10.0.8.4:6443
    KubeDNS is running at https://10.0.8.4:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    ```

#### (4) 移除 Node
- `sudo kubeadm reset`
- `rm -fr $HOME/.kube`

### 二、Masters of HA
- https://brobridge.com/bdsres/2019/08/30/%E6%9C%AC%E7%AF%87%E7%9B%AE%E6%A8%99%E6%98%AF%E9%87%9D%E5%B0%8D%E5%A6%82%E4%BD%95%E8%87%AA%E5%AD%B8%E5%BB%BA%E7%AB%8Bk8s%E6%9E%B6%E6%A7%8B/
<br><img src="https://brobridge.com/bdsres/wp-content/uploads/2019/08/image-1024x769.png">
- kubeadm init --config=kubeadm-config.yaml --upload-certs

## Node
至兩台 node 輸入上一節 worker nodes 欲加入叢集所需輸入的指令，就是這麼簡單！
<br><img src="https://www.ovh.com/blog/wp-content/uploads/2019/03/IMG_0135.jpg" alt="drawing" width="800" board="1"/>

- 加入 cluster，該 token 24 小時以內才有效
    ```bash
    kubeadm join 10.0.8.4:6443 --token 3to8hs.43xze7y3jaq29ysr --discovery-token-ca-cert-hash sha256:c3aa0c9848582ddb2332bae80e054c12868fc1d33f8023558921c014ec3c9ed1
    ```
- Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
- 失敗的話: https://stackoverflow.com/questions/55531834/kubeadm-fails-to-initialize-when-kubeadm-init-is-called
    - `echo 1 > /proc/sys/net/ipv4/ip_forward`
- 當 OS 重開後
    - `kubeadm token create`(??)
    - the value of --discovery-token-ca-cert-hash
        ```bash
        openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
        openssl dgst -sha256 -hex | sed 's/^.* //'
        ```
    - `kubectl config delete-cluster`
    - 將有關 K8S 的東西刪除
    - `sudo kubeadm reset`

## 部署 Container (try it!)
    - 部署名為 nginx 的容器，映像檔名稱為 nginx，透過參數 deployment 會自動幫你創建好 k8s 中的最小管理邏輯單位 pod 與容器
        - `kubectl create deployment nginx --image=nginx`
    - 替容器建立一個 port mapping 的 service，讓 nginx 服務可以被外部存取
        - `kubectl create service nodeport nginx --tcp=80:80`
        - 如果 ContainerCreating 太久，先停掉 service 再重新執行一次
            - `kubectl delete pod nginx-6799fc88d8-h2m6h`
    - 查詢 service mapping 的情況
        - `kubectl get pods`
        - `kubectl get services`
            ```txt
            NAME                     READY   STATUS    RESTARTS   AGE
            nginx-6799fc88d8-4bkb8   1/1     Running   0          3m36s

            NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
            kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        23m
            nginx        NodePort    10.103.227.82   <none>        80:32300/TCP   89s
            ```
    - 顯示 container 服務: http://public-ip:31550
        <br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/k8s-container-example.png?raw=true">