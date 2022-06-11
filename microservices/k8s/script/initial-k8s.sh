#!/bin/bash

echo ".... OS initial ...."
# if [[ `hostname -i` == *"10.250"* ]]; then
#     where_am_i="auo250"
#     echo "  1. I am in" $where_am_i
# else
#     where_am_i="else"
#     echo "  1. I am in" $where_am_i
# fi

echo "  2. Environment value"
LANG=en_US.UTF-8
swapoff -a
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
# timedatectl set-timezone Asia/Taipei

echo "  3. Update OS"
yum update -y | grep "Complete"
yum install epel-release -y | grep "Complete"
yum install htop -y | grep "Complete"
yum install telnet -y | grep "Complete"
yum install yum-utils device-mapper-persistent-data lvm2 -y | grep "Complete"
# yum install traceroute -y | grep "Complete"
# yum install nc -y | grep "Complete"
# yum install nmap -y | grep "Complete"
echo -e

echo ".... Docker ...."

echo "  1. Add the Docker repository"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "  2. Install Docker CE"
# yum install containerd.io docker-ce docker-ce-cli -y | grep "Complete"
yum install docker-ce -y | grep "Complete"
# echo "==== If necessary, remove it"
# yum remove containerd.io; yum remove docker

echo "  3. Set up the Docker daemon"
mkdir /etc/docker
cat << EOF | tee -a /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check=true"
    ]
}
EOF

echo "  5. Start docker"
systemctl daemon-reload
systemctl enable docker --now
# docker run hello-world
# docker ps -a
# exit

echo ".... K8S ...."
echo "  1. Letting iptables see bridged traffic"
cat << EOF | tee -a /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat << EOF | tee -a /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo "  2. Set SELinux in permissive mode (effectively disabling it)"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo -e

echo "  3. Installing kubeadm, kubelet and kubectl (DO NOT CONFIG exclude=kubelet kubeadm kubectl)"
cat << EOF | tee -a /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# yum install kubeadm kubelet kubectl -y --disableexcludes=kubernetes --nogpgcheck | grep "Complete"
yum install kubelet kubeadm -y
systemctl enable kubelet --now
kubectl completion bash | tee -a /etc/bash_completion.d/kubectl > /dev/null
echo -e

echo "  4. Install CRI-O (lightweight container runtime for kubernetes)"
VERSION=1.17:1.17.3
OS=CentOS_7
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
yum install cri-o -y
systemctl enable crio --now

echo "  5. Pull the images for kubeadm requires"
kubeadm config images pull

echo "  6. Start K8S"
systemctl daemon-reload
systemctl restart kubelet
echo -e

echo "  7. Set up autocomplete"
USER=azadmin
echo "source <(kubectl completion bash)" >> /home/$USER/.bashrc
echo "alias k=kubectl" >> /home/$USER/.bashrc
echo "complete -F __start_kubectl k" >> /home/$USER/.bashrc

echo ".... Check status ...."
systemctl status docker
echo -e
systemctl status kubelet