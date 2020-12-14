# Proxy Server
## Reference
- 原文
    - [How to Install and Configure Squid Proxy on CentOS 7](https://hostpresto.com/community/tutorials/how-to-install-and-configure-squid-proxy-on-centos-7/)
    - [Install Squid Proxy Server on CentOS 7](https://www.centlinux.com/2019/10/install-squid-proxy-server-on-centos-7.html)
- 內容看起來簡單
    - [RHEL / CentOS 7 安裝 Proxy Server — Squid](https://www.opencli.com/linux/rhel-centos-7-install-proxy-server-squid)
    - [Squid 架設](https://dywang.csie.cyut.edu.tw/dywang/linuxserver/node138.html)

## 安裝
```bash
# proxy 設定
vi /etc/yum.conf

# 一些常裝軟體
yum update -y
yum install telnet -y
yum install squid -y
```

## 啟動步驟
```bash
systemctl start squid
systemctl enable squid
systemctl status squid

# 設定好後
systemctl restart squid
```

## 修改參數
- `vi /etc/squid/squid.conf`
    ```txt
    # 定義可以存取此 proxy 的 ip，預設為內網
    acl localnet src 10.0.0.0/8     # RFC1918 possible internal network
    acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
    acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
    acl localnet src fc00::/7       # RFC 4193 local private network range
    acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

    # 定義可以取得資料的 ports
    acl SSL_ports port 443
    acl Safe_ports port 80          # http
    acl Safe_ports port 21          # ftp
    acl Safe_ports port 443         # https
    acl Safe_ports port 70          # gopher
    acl Safe_ports port 210         # wais
    acl Safe_ports port 1025-65535  # unregistered ports
    acl Safe_ports port 280         # http-mgmt
    acl Safe_ports port 488         # gss-http
    acl Safe_ports port 591         # filemaker
    acl Safe_ports port 777         # multiling http

    #
    # INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
    #
    acl allowurl url_regex -i "/etc/squid/allow_url.lst" # whitelist
    acl iconnect src 10.251.12.0/22
    http_access deny !allowurl
    http_access deny !iconnect
    http_access allow allowurl
    http_access allow iconnect

    # Squid normally listens to port 3128
    http_port 80
    ```
- `vi /etc/squid/allow_url.lst`
    ```txt
    mirrorlist.centos.org
    yum.mariadb.org
    ftp.twaren.net
    ```
- check: `netstat -tulnp | grep squid`

## Squid Analysis Report Generator
[Squid Analysis ReportGenerator](https://www.tecmint.com/sarg-squid-analysis-report-generator-and-internet-bandwidth-monitoring-tool/)
```bash
# yum
yum install gcc gd-devel make perl-GD httpd -y

# login root account and yum packages
su - root

# download sarg
wget https://sourceforge.net/projects/sarg/files/sarg/sarg-2.4.0/sarg-2.4.0.tar.gz
cd /root
tar -xvzf sarg-2.4.0.tar.gz
cd sarg-2.4.0
./configure
make && make install

# update parameter and uncomment it
vi /usr/local/etc/sarg.conf
# access_log /var/log/squid/access.log
# title "Squid User Access Reports"
# output_dir /var/www/html/squid-reports
# date_format e

# startup apache server
# please check the port 80 should be not use
systemctl start httpd
systemctl enable httpd
netstat -anpt | grep ':80'

# startup sarg
./sarg -x
```