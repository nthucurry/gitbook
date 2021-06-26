#/bin/bash
echo ".... OS initial ...."
os_name=`cat /etc/os-release | head -1`
USER=docker

echo "1. Enviroment value"
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8
echo "alias vi='vim'" >> ~/.bashrc
source ~/.bashrc
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo "2. Set proxy (Not action)"

echo "3. Update OS"
yum update -y > /dev/null 2>&1
yum install epel-release -y
yum install telnet -y > /dev/null 2>&1
yum install traceroute -y > /dev/null 2>&1
yum install nc -y > /dev/null 2>&1
yum install nmap -y > /dev/nuvill 2>&1

echo ".... Docker ...."
echo "1. Install Docker CE"
yum install yum-utils device-mapper-persistent-data lvm2 -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
echo "2. Restart docker"
systemctl start docker && systemctl enable docker
usermod -aG docker $USER && newgrp docker # it can use docker command in non root role

echo ".... K8S ...."
echo "1. Install kubectl"
# https://phoenixnap.com/kb/install-minikube-on-centos
# https://github.com/kubernetes/minikube/
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
cp ./kubectl /usr/local/bin

echo "2. Install minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
rpm -ivh minikube-latest.x86_64.rpm

# echo ".... Else ...."
# echo "7. Install perl"
# wget https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/perl-File-BaseDir-0.03-14.el7.noarch.rpm
# wget https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/perl-File-DesktopEntry-0.08-1.el7.noarch.rpm
# wget https://armv7.dev.centos.org/repodir/epel-pass-1/_imported_noarch_pkgs_from_epel/epel/Packages/p/perl-File-MimeInfo-0.21-1.el7.noarch.rpm
# rpm -Uvh perl-File-BaseDir-0.03-14.el7.noarch.rpm
# rpm -Uvh perl-File-DesktopEntry-0.08-1.el7.noarch.rpm
# rpm -Uvh perl-File-MimeInfo-0.21-1.el7.noarch.rpm
# yum install perl-File-MimeInfo