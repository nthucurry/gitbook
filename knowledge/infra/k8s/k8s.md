# Kubernetes
## Reference
- [Installing Docker on CentOS 7 With Yum](https://phoenixnap.com/kb/how-to-install-docker-centos-7)
- [Steps for Installing Kubernetes on CentOS 7](https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos)
- https://blog.tomy168.com/2019/08/centos-76-kubernetes.html
- https://blog.johnwu.cc/article/kubernetes-exercise.html
- https://ithelp.ithome.com.tw/articles/10235069?sc=iThomeR

## Information
一個可以幫助我們管理微服務(microservices)的系統，他可以自動化地部署及管理多台機器上的多個容器(container)。Kubernetes 想解決的問題是：「手動部署多個容器到多台機器上並監測管理這些容器的狀態非常麻煩。」而 Kubernetes 要提供的解法： 提供一個平台以較高層次的抽象化去自動化操作與管理容器們。

## Master
### Installing kubeadm on your hosts
- `kubeadm init --pod-network-cidr=10.244.0.0/16`
    - 使用 Flannel CNI
- 用 non-root user 執行
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```
### Installing a Pod network add-on
- `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml`
    - 出現錯誤: The connection to the server localhost:8080 was refused - did you specify the right host or port?
        - [權限不足](https://developer.aliyun.com/article/652961): `echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile && . ~/.bash_profile`
- `kubectl get pods --all-namespaces`
    ```txt
    NAMESPACE     NAME                                 READY   STATUS    RESTARTS   AGE
    kube-system   coredns-f9fd979d6-sdb6d              0/1     Pending   0          3h12m
    kube-system   coredns-f9fd979d6-vzwpg              0/1     Pending   0          3h12m
    kube-system   etcd-k8s-master                      1/1     Running   0          3h12m
    kube-system   kube-apiserver-k8s-master            1/1     Running   0          3h12m
    kube-system   kube-controller-manager-k8s-master   1/1     Running   0          3h12m
    kube-system   kube-proxy-nqgbz                     1/1     Running   0          3h12m
    kube-system   kube-scheduler-k8s-master            1/1     Running   0          3h12m
    ```

## Node
- 加入 cluster
    ```bash
    kubeadm join 10.0.0.5:6443 --token qowet6.ymjikzk5nvk1i3g7 \
    --discovery-token-ca-cert-hash sha256:7d831165f775e27bb6b0cf2c193e867c50ffe12f093f7261650d0b5699ea30d8
    ```