#/bin/bash

### define
os_name=`cat /etc/os-release | head -1`
user=tonylee
proxy_ip="10.250.12.5" && proxy_hostname="squid" && proxy_port=3128

### enviroment
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8

### internet connection
# echo "proxy=http://$proxy_hostname:$proxy_port" >> /etc/yum.conf
# echo "https_proxy = http://$proxy_hostname:$proxy_port" >> /etc/wgetrc
# echo "http_proxy = http://$proxy_hostname:$proxy_port" >> /etc/wgetrc

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
source ~/.bashrc

## DNS
echo "==== DNS... ===="
# echo "$proxy_ip $proxy_hostname" >> /etc/hosts

### systemctl
echo "==== systemctl... ===="
systemctl stop firewalld && systemctl disable firewalld

### 1. Install default package
echo "==== 1. Install default package ===="
yum update -y
yum install telnet -y > /dev/null 2>&1
yum install traceroute -y > /dev/null 2>&1

### 2. Install kubectl
echo "==== 2. Install kubectl"
# https://phoenixnap.com/kb/install-minikube-on-centos
# https://github.com/kubernetes/minikube/
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin

### Install docker (you can use virtualbox)
echo "==== 3. Install docker"
yum install yum-utils device-mapper-persistent-data lvm2 -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
systemctl start docker && systemctl enable docker
usermod -aG docker $user # it can use docker command in non root role

### Install minikube
echo "==== 4. Install minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
rpm -ivh minikube-latest.x86_64.rpm

### Install perl
echo "==== 4. Install perl"
wget https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/perl-File-BaseDir-0.03-14.el7.noarch.rpm
wget https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/perl-File-DesktopEntry-0.08-1.el7.noarch.rpm
wget https://armv7.dev.centos.org/repodir/epel-pass-1/_imported_noarch_pkgs_from_epel/epel/Packages/p/perl-File-MimeInfo-0.21-1.el7.noarch.rpm
rpm -Uvh perl-File-BaseDir-0.03-14.el7.noarch.rpm
rpm -Uvh perl-File-DesktopEntry-0.08-1.el7.noarch.rpm
rpm -Uvh perl-File-MimeInfo-0.21-1.el7.noarch.rpm
yum install perl-File-MimeInfo