#/bin/bash
echo ".... OS initial ...."
os_name=`cat /etc/os-release | head -1`
USER=azadmin
k8s_ip=`ifconfig | grep inet | awk '{print $2}' | head -1`
if [[ $k8s_ip == *"10.250"* ]]; then
    where_am_i="auo250"
    echo "1. I am in" $where_am_i
else
    where_am_i="else"
    echo "1. I am in" $where_am_i
fi

### enviroment
echo "2. Enviroment value"
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8
swapoff -a
echo "alias vi='vim'" >> ~/.bashrc
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc
source ~/.bashrc
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
# systemctl restart sshd
# systemctl stop firewalld
# systemctl disable firewalld

if [ $where_am_i == "auo250" ]; then
    echo "3. Set proxy"
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
    echo "3. Not action"
fi

echo "4. Update OS"
yum update -y > /dev/null 2>&1
yum install epel-release -y
yum install telnet -y > /dev/null 2>&1
yum install traceroute -y > /dev/null 2>&1
yum install nc -y > /dev/null 2>&1
yum install nmap -y > /dev/nuvill 2>&1

echo ".... Docker ...."
echo "1. Install Docker CE"
yum install yum-utils device-mapper-persistent-data lvm2 -y
echo "2. Add the Docker repository"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo "3. Install Docker CE"
# yum install containerd.io-1.2.13 docker-ce-19.03.11 docker-ce-cli-19.03.11 -y
yum install containerd.io docker-ce docker-ce-cli -y
# echo "==== If necessary, remove it"
# yum remove containerd.io && yum remove docker
echo "4. Set up the Docker daemon"
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
echo "5. Restart docker"
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

echo ".... K8S ...."
echo "1. Letting iptables see bridged traffic"
cat << EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

echo "2. Install using native package management"
cat << EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# 3. Set SELinux in permissive mode (effectively disabling it)
# echo "==== Set SELinux in permissive mode (effectively disabling it)"
# sudo setenforce 0
# sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

echo "3. Restarting K8S"
systemctl daemon-reload
systemctl restart kubelet
systemctl enable kubelet