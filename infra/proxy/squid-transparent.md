# Reference
- [Setup Squid Transparent Proxy with Docker](https://maple52046.github.io/posts/setup-squid-transparent-proxy-with-docker/)
- [Firewall rules based on Domain name instead of IP address](https://unix.stackexchange.com/questions/557388/firewall-rules-based-on-domain-name-instead-of-ip-address)
- [Using Azure Firewall or Squid as virtual appliance in Azure Route Table to overwrite Internet outbound system route of Azure VMs](https://jasonpangazure.medium.com/how-to-use-azure-firewall-and-squid-as-virtual-appliance-in-azure-route-table-to-overwrite-debc98b8f0b8)
- [How to set up a transparent proxy on Linux](https://www.xmodulo.com/how-to-set-up-transparent-proxy-on-linux.html)

# Install
## CentOS
```bash
yum update -y
yum install epel-release -y
yum install http://ngtech.co.il/repo/centos/7/squid-repo-1-1.el7.centos.noarch.rpm -y
yum install squid -y
yum install iptables-services -y

echo "alias srs='systemctl restart squid.service'" >> /etc/bashrc
echo "alias sss='systemctl status squid.service'" >> /etc/bashrc
echo "alias vi='vim'" >> /etc/bashrc
source /etc/bashrc

# 網路
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# 修改 squid.conf
ln -s /etc/squid/squid.conf
vi squid.conf

# check log
ln -s /var/log/squid/access.log
tail -10f access.log | grep -Ev "10.250.48.196|10.250.48.200"

# Certificate
mkdir -p /etc/squid/certs
cd /etc/squid/certs
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/infra/proxy/certs/ssl.conf

# OS firewall
iptables -t nat -A PREROUTING -p tcp --dport  80 -j REDIRECT --to 3128
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to 3129
iptables-save

# https connection
ssl_crtd=$(find /usr -type f -name ssl_crtd)
${ssl_crtd} -c -s /var/lib/ssl_db
chown -R squid /var/lib/ssl_db

/usr/sbin/squid -f /etc/squid/squid.conf
```

## Ubuntu
```bash
apt update -y
apt install vim -y
apt install net-tools -y
apt install iptables -y

wget -qO - https://packages.diladele.com/diladele_pub.asc | sudo apt-key add -
echo "deb https://squid413-ubuntu20.diladele.com/ubuntu/ focal main" \
    > /etc/apt/sources.list.d/squid413-ubuntu20.diladele.com.list

apt install squid -y
apt install squidclient -y
apt install squid-openssl -y
apt install squid-common -y
apt install libecap3 libecap3-dev
squid -v
# Squid Cache: Version 4.13

systemctl enable squid.service --now

echo "alias srs='systemctl restart squid.service'" >> ~/.bashrc
echo "alias sss='systemctl status squid.service'" >> ~/.bashrc
echo "alias vi='vim'" >> ~/.bashrc
source ~/.bashrc

# 網路
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# 修改 squid.conf
ln -s /etc/squid/squid.conf
vi squid.conf

# check log
ln -s /var/log/squid/access.log
tail -10f access.log
tcpdump | grep -Ev "168.63.129.16|ssh"
traceroute maz-ohfs01.corpnet.auo.com

# OS firewall
iptables -t nat -A PREROUTING -p tcp --dport  80 -j REDIRECT --to 3128
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to 3129
iptables-save
```

# squid.conf
```
http_access allow localnet
http_port 3127
http_port 3128 transparent
https_port 3129 transparent ssl-bump cert=/etc/squid/certs/server.crt key=/etc/squid/certs/server.key
```

# Azure
- NSG
    - inbound: VirtualNetwork, Internet, 80_443, TCP
- IP forwarding
    - enable