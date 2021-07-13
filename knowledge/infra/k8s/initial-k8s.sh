#!/bin/bash

echo ".... OS initial ...."
USER=azadmin
os_name=`cat /etc/os-release | head -1`
if [[ `hostname -i` == *"10.250"* ]]; then
    where_am_i="auo250"
    echo "  1. I am in" $where_am_i
else
    where_am_i="else"
    echo "  1. I am in" $where_am_i
fi

echo "  2. Environment value"
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8
swapoff -a
echo "alias vi='vim'" >> /home/$USER/.bashrc
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "  3. Proxy"
if [ $where_am_i == "auo250" ]; then
    echo "    * Set proxy"
cat >> /root/.bashrc << EOF
export http_proxy=http://10.250.12.5:3128
export https_proxy=https://10.250.12.5:3128
EOF

    mkdir -p /etc/systemd/system/docker.service.d
    touch /etc/systemd/system/docker.service.d/proxy.conf
    sudo echo '
    [Service]
    Environment="HTTP_PROXY=http://10.250.12.5:3128"
    Environment="HTTPS_PROXY=http://10.250.12.5:3128"
    ' >> /etc/systemd/system/docker.service.d/proxy.conf

    echo "proxy=http://10.250.12.5:3128" >> /etc/yum.conf
    echo "https_proxy=http://10.250.12.5:3128" >> /etc/wgetrc
    echo "http_proxy=http://10.250.12.5:3128" >> /etc/wgetrc
else
    echo "    * Not action"
fi

echo "  4. Update OS"
yum update -y | grep "Complete!"
yum install epel-release -y | grep "Complete!"
yum install htop -y | grep "Complete!"
yum install telnet -y | grep "Complete!"
yum install traceroute -y | grep "Complete!"
yum install nc -y | grep "Complete!"
yum install nmap -y | grep "Complete!"
echo -e

echo ".... Docker ...."
echo "  1. Install Docker CE"
yum install yum-utils device-mapper-persistent-data lvm2 -y | grep "Complete!"

echo "  2. Add the Docker repository"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "  3. Install Docker CE"
# yum install containerd.io-1.2.13 docker-ce-19.03.11 docker-ce-cli-19.03.11 -y | grep Complete
yum install containerd.io docker-ce docker-ce-cli -y | grep "Complete!"
# echo "==== If necessary, remove it"
# yum remove containerd.io && yum remove docker

echo "  4. Set up the Docker daemon"
mkdir /etc/docker
cat << EOF | tee /etc/docker/daemon.json
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
systemctl enable docker
systemctl start docker

echo ".... K8S ...."
echo "  1. Letting iptables see bridged traffic"
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

echo "  2. Set SELinux in permissive mode (effectively disabling it)"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo -e

echo "  3. Installing kubeadm, kubelet and kubectl"
cat << EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
yum install kubeadm kubelet kubectl -y --disableexcludes=kubernetes | grep "Complete!"
systemctl enable --now kubelet
echo -e

echo "  4. Pull the images for kubeadm requires"
kubeadm config images pull

# echo "  5. Install weave net"
# curl -L git.io/weave -o /usr/local/bin/weave
# chmod a+x /usr/local/bin/weave

echo "  6. Start K8S"
systemctl daemon-reload
systemctl restart kubelet
systemctl enable kubelet
echo -e

echo "  7. Set up autocomplete"
# sudo -u $USER source <(kubectl completion bash)
sudo -u $USER echo "source <(kubectl completion bash)" >> /home/$USER/.bashrc
source /home/$USER/.bashrc

echo ".... Check status ...."
systemctl status docker
echo -e
systemctl status kubelet