# Kubernetes
## Initital
```bash
#/bin/bash

### define
proxy_server=squid
proxy_ip="10.0.0.6"
proxy_port=3128

### enviroment
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8

### DNS
echo "$proxy_ip $proxy_server" >> /etc/hosts

### internet connection
echo "proxy=http://$proxy_server:$proxy_port" >> /etc/yum.conf
echo "https_proxy = http://$proxy_server:$proxy_port" >> /etc/wgetrc
echo "http_proxy = http://$proxy_server:$proxy_port" >> /etc/wgetrc

### yum
yum update -y
yum install wget -y
yum install telnet -y
yum install traceroute -y
yum install nfs-utils -y
yum install zip unzip -y

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
source ~/.bashrc

### systemctl
echo "==== firewalld... ===="
systemctl stop firewalld
systemctl disable firewalld
```

## SOP
- Repo setting
    ```txt
    cat << EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF
    ```
- `yum install kubelet kubeadm kubectl -y`
- `systemctl enable kubelet`
- `systemctl start kubelet`

