- [前言](#前言)
- [安裝 Squid](#安裝-squid)
- [修改參數](#修改參數)
    - [設定 Header & TLS (未完成)](#設定-header--tls-未完成)
    - [Header 測試工具](#header-測試工具)
        - [Fiddler](#fiddler)
        - [Wireshark](#wireshark)
    - [OS 設定位置](#os-設定位置)
- [安裝報表 (Squid Analysis Report Generator)](#安裝報表-squid-analysis-report-generator)

# 前言
[架設 Proxy over TLS](https://blog.gslin.org/archives/2021/03/11/10057/%E6%9E%B6%E8%A8%AD-proxy-over-tls/)

>HTTP Proxy 算是很好用的跳板手段，瀏覽器有很多套件可以依照各種條件自動切換到不同的 Proxy 上面。
>
>但一般在使用 HTTP Proxy (走 Port 3128 或是 8080 的那種) 使用明文傳輸，就不適合使用 Proxy-Authenticate 把帳號密碼帶進去 (出自 RFC 7235 的「Hypertext Transfer Protocol (HTTP/1.1): Authentication」)
>
>查了一些資料後發現，現在的瀏覽器基本上都支援 Proxy over TLS 了，也就是 Proxy Protocol 外面包一層 TLS，保護瀏覽器到 Proxy 中間的流量。

# 安裝 Squid
```bash
yum update -y
yum install epel-release -y
yum install htop -y
yum install telnet -y
yum install nc -y
yum install squid -y
yum clean all

timedatectl set-timezone Asia/Taipei
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

# 修改參數
- `vi /etc/squid/squid.conf`
    ```
    # 定義可以存取此 proxy 的 ip，預設為內網
    acl localnet src 10.0.0.0/8     # RFC 1918 possible internal network
    acl localnet src 172.16.0.0/12  # RFC 1918 possible internal network
    acl localnet src 192.168.0.0/16 # RFC 1918 possible internal network
    acl localnet src fc00::/7       # RFC 4193 local private network range
    acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

    # 定義可以取得資料的 ports
    acl SSL_ports port 443
    acl Safe_ports port 80          # http
    acl Safe_ports port 443         # https

    #
    # INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
    #
    acl allowurl url_regex -i "/etc/squid/allow_url.lst" # whitelist
    acl iconnect src 10.251.12.0/22
    acl iconnect src 111.249.192.18
    http_access deny !allowurl
    http_access deny !iconnect
    http_access allow allowurl
    http_access allow iconnect

    # Squid normally listens to port 3128
    http_port 3128
    ```
- `vi /etc/squid/allow_url.lst`
    ```
    mirrorlist.centos.org
    yum.mariadb.org
    ftp.twaren.net
    ```
- check: `netstat -tulnp | grep squid`

## 設定 Header & TLS (未完成)
- 建立放憑證的資料夾
    ```bash
    mkdir -p /etc/squid/certs
    cd /etc/squid/certs
    ```
- 產生 self-signed SSL certificate and trusted certificate
    ```bash
    # 用 openssl 創建 CA 證書 (PEM 格式，有效期為一年)
    #openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout squid-ca-key.pem -out squid-ca-cert.pem
    openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_req -keyout server.key -out server.crt -config ssl.conf

    # 做啥用的?
    cat server.crt server.key >> squid-ca-cert-key.pem

    # 產生 CSR (需重打 ssl.conf 資訊)
    openssl req -out server.csr -key server.key -new

    chown squid:squid -R /etc/squid/certs
    ```
- 產生 PEM (crt 轉成 cer，DER 編碼二進制格式)
    ```bash
    openssl x509 -outform DER -in server.crt -out server.cer
    ```
- 修改 squid.conf
    ```
    # Replace http_port in the /etc/squid/squid.conf
    # http_port 3128
    http_port 3128 ssl-bump \
        cert=/etc/squid/certs/squid-ca-cert-key.pem \
        generate-host-certificates=on dynamic_cert_mem_cache_size=16MB
    https_port 3129 intercept ssl-bump \
        cert=/etc/squid/certs/squid-ca-cert-key.pem \
        generate-host-certificates=on dynamic_cert_mem_cache_size=16MB
    sslcrtd_program /usr/lib64/squid/ssl_crtd -s /var/lib/ssl_db -M 16MB
    acl step1 at_step SslBump1
    ssl_bump peek step1
    ssl_bump bump all
    ssl_bump splice all

    # Add Azure Header
    request_header_add Restrict-Access-To-Tenants "<primary domain>.onmicrosoft.com" all
    request_header_add Restrict-Access-Context "<tenant ID>" all
    ```
- 檢查 squid 組態正確性
    ```bash
    squid -k parse
    ```
- 初始化憑證資料夾
    ```bash
    /usr/lib64/squid/ssl_crtd -c -s /var/lib/ssl_db
    ```
- Test
    ```bash
    curl --proxy http://squid.gotdns.ch:3128 ipinfo.io
    ```

## Header 測試工具
### Fiddler
```csharp
// Allows access to the listed tenants.
if (
    oSession.HostnameIs("login.microsoftonline.com") ||
    oSession.HostnameIs("login.microsoft.com") ||
    oSession.HostnameIs("login.windows.net")
    )
{
    oSession.oRequest["Restrict-Access-To-Tenants"] = "<primary domain>.onmicrosoft.com";
    oSession.oRequest["Restrict-Access-Context"] = "<tenant ID>";
}

// Blocks access to consumer apps
if (
    oSession.HostnameIs("login.live.com")
    )
{
    oSession.oRequest["sec-Restrict-Tenant-Access-Policy"] = "restrict-msa";
}
```
### Wireshark
https://wiki.wireshark.org/HTTP_Preferences
- `ip.src == 10.0.8.5 && ip.dst == 10.0.8.4 &&  http && tcp.port == 3128`

## OS 設定位置
- windows
    <br><img src="../../img/proxy/windows-config.png">
- linux
    - `/etc/yum.conf`
    - `export http_proxy=http://squid.gotdns.ch:3128`
    - `export https_proxy=https://squid.gotdns.ch:3128`

# 安裝報表 (Squid Analysis Report Generator)
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