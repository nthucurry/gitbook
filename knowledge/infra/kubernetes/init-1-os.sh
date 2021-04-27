#/bin/bash

#### necessary
where_am_i="home"

### define
os_name=`cat /etc/os-release | head -1`
USER=azadmin
k8s_ip=`ifconfig | grep inet | awk '{print $2}' | head -1`
# proxy_ip="10.1.1.5"
# proxy_hostname="proxy"
# proxy_port=3128

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
echo "The VMs is in" $where_am_i
if [ $where_am_i == "auo" ]; then
    ### user account setting
    echo "==== user account setting ===="
cat >> /home/$USER/.bash_profile << EOF
export http_proxy=http://$proxy_hostname:$proxy_port
export https_proxy=https://$proxy_hostname:$proxy_port
export DISPLAY=$k8s_ip:0.0
EOF
    ### internet connection
    echo "==== proxy ===="
    echo "proxy=http://$proxy_ip:$proxy_port" >> /etc/yum.conf
    echo "https_proxy=http://$proxy_ip:$proxy_port" >> /etc/wgetrc
    echo "http_proxy=http://$proxy_ip:$proxy_port" >> /etc/wgetrc
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