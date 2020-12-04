# Kubernetes
## Reference
- [Installing Docker on CentOS 7 With Yum](https://phoenixnap.com/kb/how-to-install-docker-centos-7)
- [Steps for Installing Kubernetes on CentOS 7](https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos)
- https://blog.tomy168.com/2019/08/centos-76-kubernetes.html
- https://blog.johnwu.cc/article/kubernetes-exercise.html

## Information
一個可以幫助我們管理微服務(microservices)的系統，他可以自動化地部署及管理多台機器上的多個容器(container)。Kubernetes 想解決的問題是：「手動部署多個容器到多台機器上並監測管理這些容器的狀態非常麻煩。」而 Kubernetes 要提供的解法： 提供一個平台以較高層次的抽象化去自動化操作與管理容器們。

## Initital
```bash
#/bin/bash

### define
user=poc
master_ip="10.0.0.5" && master_hostname="k8s-master"
node1_ip="10.0.0.6" && node1_hostname="k8s-node1"
node2_ip="10.0.0.7" && node2_hostname="k8s-node2"
proxy_ip="10.0.0.4" && proxy_hostname="squid" && proxy_port=80

### enviroment
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8

### internet connection
echo "proxy=http://$proxy_hostname:$proxy_port" >> /etc/yum.conf
echo "https_proxy = http://$proxy_server:$proxy_port" >> /etc/wgetrc
echo "http_proxy = http://$proxy_server:$proxy_port" >> /etc/wgetrc

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
source ~/.bashrc

## DNS
echo "==== DNS... ===="
echo "$proxy_ip $proxy_hostname" >> /etc/hosts
echo "$master_ip $master_hostname" >> /etc/hosts
echo "$node1_ip $node1_hostname" >> /etc/hosts
echo "$node2_ip $node2_hostname" >> /etc/hosts

### systemctl
echo "==== systemctl... ===="
systemctl stop firewalld && systemctl disable firewalld

### yum default
echo "==== yum default... ===="
yum update -y > /dev/null 2>&1
yum install telnet -y > /dev/null 2>&1
yum install traceroute -y > /dev/null 2>&1
yum install nfs-utils -y > /dev/null 2>&1

### yum docker
echo "==== yum docker... ===="
yum install yum-utils device-mapper-persistent-data lvm2 -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
systemctl start docker && systemctl enable docker

### yum k8s
cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install kubelet kubeadm kubectl -y
systemctl enable kubelet && systemctl start kubelet
```

## Master
- `kubeadm init --pod-network-cidr=10.244.0.0/16`
- 用 regular user account 執行
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```
- `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml`
    - 出現錯誤: The connection to the server localhost:8080 was refused - did you specify the right host or port?
        - [權限不足](https://developer.aliyun.com/article/652961): `echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile && . ~/.bash_profile`

## Node
- 加入 cluster
    ```bash
    kubeadm join 10.0.0.5:6443 --token 17o1wx.2wqt767lth11ld7j \
    --discovery-token-ca-cert-hash sha256:e3641974bcb7d4dd2daa6d48f8b9c4a7b5050e0e5d0b8827ca9f0765a6c880ef
    ```