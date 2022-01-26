#/bin/bash

### define
os_name=`cat /etc/os-release | head -1`
user=oracle
sid=demo1
uqname=$sid
base=/u01/oracle
ora_ver=11204
home=$base/$ora_ver
swap_size=4

### enviroment
timedatectl set-timezone Asia/Taipei
LANG=en_US.UTF-8
NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

### update parameter
echo "alias vi='vim'" >> /etc/bashrc
echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
source /etc/bashrc

### systemctl
echo "==== systemctl ===="
# systemctl restart sshd
systemctl stop firewalld && systemctl disable firewalld

### swap
echo "==== swap ===="
dd if=/dev/zero of=/swapfile count=$swap_size bs=1GiB
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile swap swap sw 0 0" >> /etc/fstab

### yum
echo "==== yum ===="
yum update -y > /dev/null 2>&1
yum install epel-release -y
yum install telnet -y
yum install traceroute -y
yum install nfs-utils -y
yum install zip unzip -y
yum install nc -y
# yum install matchbox-window-manager xterm -y
if [[ "$os_name" == *"Oracle Linux Server"* ]]; then
    echo "==== yum(Server with GUI) ===="
    yum groupinstall "Server with GUI" -y > /dev/null 2>&1
    echo "==== yum(Server with GUI end) ===="
else
    echo "==== yum(GNOME Desktop) ===="
    yum groupinstall "GNOME Desktop" -y > /dev/null 2>&1
    echo "==== yum(GNOME Desktop end) ===="
fi
yum install ksh gcc* libaio* glibc-* libXi* libXtst* unixODBC* compat-libstdc* libstdc* libgcc* binutils* compat-libcap1* make* stsstat* -y > /dev/null 2>&1
yum clean all

### group
echo "==== group ===="
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
# groupadd -g 54324 backupdba
# groupadd -g 54325 dgdba
# groupadd -g 54326 kmdba
# groupadd -g 54327 asmdba
# groupadd -g 54328 asmoper
# groupadd -g 54329 asmadmin
# groupadd -g 54330 racdba
# useradd -m oracle
usermod -g oinstall -G dba,oper oracle

### directory
mkdir -p /u01/oraarch/$sid
mkdir -p /u01/oradata/$sid
mkdir /oracle
mkdir /backup

### owner
chown -R $user:dba /u01
chown -R $user:dba /oracle
chown -R $user:dba /backup

### oracle prerequisite
echo "==== oracle package ===="
wget http://public-yum.oracle.com/public-yum-ol7.repo -O /etc/yum.repos.d/public-yum-ol7.repo
wget http://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
if [[ "$ora_ver" -eq 11204 ]]; then
    yum install oracle-rdbms-server-11gR2-preinstall -y
else
    yum install oracle-database-server-12cR2-preinstall -y
fi

### oracle account setting
echo "==== oracle account ===="
cat >> /home/$user/.bash_profile << EOF
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
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

# Alias
alias sqlp='sqlplus / as sysdba'
alias rm='rm -i'
alias vi='vim'
alias ll='ls -l'
alias grep='grep --color=always'
alias tree='tree --charset ASCII'
alias bdump="cd $base/diag/rdbms/${uqname,,}/$sid/trace"
EOF