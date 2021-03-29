#/bin/bash

#### necessary
where_am_i=home

### define
os_name=`cat /etc/os-release | head -1`
master_ip="10.0.8.4" && master_hostname="k8s-master"
node1_ip="10.0.8.5" && node1_hostname="k8s-node1"
node2_ip="10.0.8.6" && node2_hostname="k8s-node2"
# proxy_ip="10.1.1.5" && proxy_hostname="k8s-master" && proxy_port=3128

### enviroment
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8
swapoff -a

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc
source ~/.bashrc

### systemctl
echo "==== systemctl ===="
systemctl restart sshd
systemctl stop firewalld && systemctl disable firewalld

### yum
echo "==== yum ===="
yum update -y > /dev/null 2>&1
yum install epel-release -y
yum install telnet -y > /dev/null 2>&1
yum install traceroute -y > /dev/null 2>&1
yum install nc -y > /dev/null 2>&1

#### option
if [ "$where_am_i" -eq "auo" ]; then
    ### DNS
    echo "==== DNS ===="
    echo "$proxy_ip $proxy_hostname" >> /etc/hosts
    echo "$master_ip $master_hostname" >> /etc/hosts
    echo "$node1_ip $node1_hostname" >> /etc/hosts
    echo "$node2_ip $node2_hostname" >> /etc/hosts

    ### user account setting
    echo "==== user account setting ===="
    cat >> /home/$USER/.bash_profile << EOF
    export http_proxy=http://$proxy_hostname:$proxy_port
    export https_proxy=https://$proxy_hostname:$proxy_port
    EOF

    ### internet connection
    echo "==== proxy ===="
    echo "proxy=http://$proxy_hostname:$proxy_port" >> /etc/yum.conf
    echo "https_proxy=http://$proxy_hostname:$proxy_port" >> /etc/wgetrc
    echo "http_proxy=http://$proxy_hostname:$proxy_port" >> /etc/wgetrc
else
    echo "not action"
fi
