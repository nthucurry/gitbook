#/bin/bash

### define
proxy_server=occ
proxy_ip="10.140.0.10"
user=oracle
sid=ERP
uqname=$sid
base=/u01/oracle
ora_ver=12201
home=$base/$ora_ver
bpfile=.bash_profile
swap_size=8

### DNS
echo "$proxy_ip $proxy_server" >> /etc/hosts

### internet connection
echo "proxy=http://$proxy_server:80" >> /etc/yum.conf
echo "https_proxy = http://$proxy_server:80/" >> /etc/wgetrc
echo "http_proxy = http://$proxy_server:80/" >> /etc/wgetrc

### yum
echo "==== yum... ===="
yum update -y
yum install wget -y
yum install telnet -y
yum install traceroute -y
yum install nfs-utils -y
yum install zip unzip -y
yum groupinstall "GNOME Desktop" -y
yum install ksh gcc* libaio* glibc-* libXi* libXtst* unixODBC* compat-libstdc* libstdc* libgcc* binutils* compat-libcap1* make* stsstat* -y

### timezone
echo "==== timedatectl... ===="
timedatectl set-timezone Asia/Taipei

### update parameter
echo "alias vi='vim'" >> ~/.bashrc
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
source ~/.bashrc

### swap
echo "==== swap... ===="
dd if=/dev/zero of=/swapfile count=$swap_size bs=1GiB
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile swap swap sw 0 0" >> /etc/fstab

### systemctl
echo "==== firewalld... ===="
systemctl stop firewalld
systemctl disable firewalld

### oracle prerequisite
echo "==== oracle package... ===="
wget http://public-yum.oracle.com/public-yum-ol7.repo -O /etc/yum.repos.d/public-yum-ol7.repo
wget http://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
if [ "$ora_ver" -eq 11204 ]; then
    yum install oracle-rdbms-server-11gR2-preinstall -y
else
    yum install oracle-database-server-12cR2-preinstall -y
fi

### group
echo "==== group... ===="
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
groupadd -g 54324 backupdba
groupadd -g 54325 dgdba
groupadd -g 54326 kmdba
groupadd -g 54327 asmdba
groupadd -g 54328 asmoper
groupadd -g 54329 asmadmin
groupadd -g 54330 racdba
usermod -g oinstall -G dba,oper oracle

### directory
mkdir /u01
mkdir /oracle
mkdir /backup

### owner
chown -R $user:dba /u01
chown -R $user:dba /oracle
chown -R $user:dba /backup

### enviromnent variable
LANG=en_US.UTF-8
env

### oracle account setting
echo "==== oracle account... ===="
cat >> /home/$user/$bpfile <<EOF
export ORACLE_SID=$sid
export ORACLE_UNQNAME=$uqname # it is difference between primary and standby database
export ORACLE_BASE=$base
export ORACLE_HOME=$home
export TNS_ADMIN=$home/network/admin
LD_LIBRARY_PATH=$home/lib:/lib:/usr/lib;
export LD_LIBRARY_PATH
CLASSPATH=$home/JRE:$home/jlib:$home/rdbms/jlib;
export CLASSPATH
PATH=$PATH:$home/bin:$home/bin
export PATH

# Alias
alias sqlp='sqlplus / as sysdba'
alias rm='rm -i'
alias vi='vim'
alias ll='ls -lrt'
alias grep='grep --color=always'
alias tree='tree --charset ASCII'
alias bdump="cd $base/diag/rdbms/${uqname,,}/$sid/trace"
EOF