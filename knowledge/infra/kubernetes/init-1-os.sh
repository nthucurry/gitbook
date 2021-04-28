#/bin/bash

#### necessary
where_am_i="home" # home, auo250, auo248

### define
os_name=`cat /etc/os-release | head -1`
USER=azadmin
k8s_ip=`ifconfig | grep inet | awk '{print $2}' | head -1`

### enviroment
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8
swapoff -a

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc
source ~/.bashrc
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

### systemctl
echo "==== systemctl ===="
systemctl restart sshd
systemctl stop firewalld
systemctl disable firewalld

#### option
echo "The VM is in" $where_am_i
if [ $where_am_i == "auo250" ]; then
    echo "set proxy"
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
    echo "not action"
fi

### yum
echo "==== yum ===="
yum update -y > /dev/null 2>&1
yum install epel-release -y
yum install telnet -y > /dev/null 2>&1
yum install traceroute -y > /dev/null 2>&1
yum install nc -y > /dev/null 2>&1
yum install nmap -y > /dev/nuvill 2>&1