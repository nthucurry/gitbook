#/bin/bash

### yum
yum update -y
yum install wget -y
yum install telnet -y
yum install traceroute -y
yum install nfs-utils -y
yum install zip unzip -y
yum groupinstall "GNOME Desktop" -y
yum install ksh gcc* libaio* glibc-* libXi* libXtst* unixODBC* compat-libstdc* libstdc* libgcc* binutils* compat-libcap1* make* stsstat* -y

### timezone
timedatectl set-timezone Asia/Taipei

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

### swap
dd if=/dev/zero of=/swapfile count=8 bs=1GiB
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile swap swap sw 0 0" >> /etc/fstab

###
systemctl stop firewalld
systemctl disable firewalld