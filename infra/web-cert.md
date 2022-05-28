- [參考](#參考)
- [彼此關係](#彼此關係)
- [轉換憑證格式](#轉換憑證格式)
- [NGINX](#nginx)
- [Tomcat](#tomcat)
- [Apache](#apache)

# 參考
- https://www.ionos.com/digitalguide/server/configuration/apache-tomcat-on-centos/
- https://downloads.apache.org/tomcat/tomcat-9/
- [NGINX 設定 HTTPS 網頁加密連線，建立自行簽署的 SSL 憑證](https://blog.gtwang.org/linux/nginx-create-and-install-ssl-certificate-on-ubuntu-linux/)
- 免費 SSL 認證: https://manage.sslforfree.com/dashboard
- [My No-IP](https://my.noip.com/)

# 彼此關係
1. 客戶產生後，給憑證經銷商
   - 私密金鑰檔
   - 憑證要求檔 (server.csr)
2. 憑證經銷商給客戶
   - 伺服器憑證
3. 客戶合併**伺服器憑證** + **私密金鑰檔** --> server-my.pfx
   - `openssl pkcs12 -in server.cer -inkey my.key -export -out server-my.pfx -password pass:1234`
4. 從 server-my.pfx 匯出**伺服器憑證檔** + **私密金鑰檔**
   - `openssl pkcs12 -in server-my.pfx -nokeys -password "pass:1234" -out - 2>/dev/null | openssl x509 -out server.crt`

# 轉換憑證格式
```bash
# crt 轉成 cer (DER 編碼二進制格式)
openssl x509 -in cert.pem -out FindARTs.der -outform der

openssl x509 -in FindARTs.der -out FindARTs.cer -inform DER
openssl pkcs12 -in FindARTs.cer -inkey privkey.pem -export -out FindARTs.pfx -password pass:1234
# cer 轉成 crt (DER 編碼二進制格式)
openssl x509 -in server.cer -out server2.crt -inform DER

openssl pkcs12 -in cert.pem -inkey privkey.pem -export -out FindARTs.pfx -password pass:1234
```

# NGINX
- `mkdir /etc/nginx/ssl`
- 產生自我簽署的金鑰 (trusted certificate)
    - `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt`
        ```
        Country Name (2 letter code) [XX]:TW
        State or Province Name (full name) []:Taiwan
        Locality Name (eg, city) [Default City]:Taipei
        Organization Name (eg, company) [Default Company Ltd]:Test Inc.
        Organizational Unit Name (eg, section) []:IT Department
        Common Name (eg, your name or your server's hostname) []:api.ddns.net
        Email Address []:admin@example.com
        ```
- 更新設定檔
    - `vi /etc/nginx/nginx.conf`
        ```
        server {
            listen       80;
            listen       [::]:80;
            server_name  _;
            root         /usr/share/nginx/html;

            listen 443 ssl default_server;
            listen [::]:443 ssl default_server;

            ssl_certificate /etc/nginx/ssl/nginx.crt;
            ssl_certificate_key /etc/nginx/ssl/nginx.key;

            ...
        ```
- 重啟服務
- 產出 pfx 憑證 (windows)
    - `openssl pkcs12 -export -out nginx.pfx -inkey nginx.key -in nginx.crt`

# Tomcat
- 安裝 Tomcat
    - `yum install tomcat`
    - `yum install tomcat-webapps tomcat-admin-webapps tomcat-docs-webapp tomcat-javadoc`
- 改 port
    - `vi /etc/tomcat/server.xml`
- 安裝憑證
    ```
    [azadmin@vm-tomcat ~]$ ls
    apache-tomcat-9.0.44.zip  apache-tomcat-9.0.44.zip.sha512  auoca2021.key  auoca2021.pem
    [azadmin@vm-tomcat ~]$ openssl pkcs12 -export -in auoca2021.pem -out auoca2021.pfx
    Enter Export Password:
    Verifying - Enter Export Password:
    [azadmin@vm-tomcat ~]$ ls
    apache-tomcat-9.0.44.zip  apache-tomcat-9.0.44.zip.sha512  auoca2021.key  auoca2021.pem  auoca2021.pfx
    [azadmin@vm-tomcat ~]$ sudo cp auoca2021.pfx /usr/share/tomcat/conf/
    [azadmin@vm-tomcat conf]$ sudo vim server.xml
    [azadmin@vm-tomcat conf]$ sudo systemctl stop tomcat.service
    [azadmin@vm-tomcat conf]$ sudo systemctl start tomcat.service
    [azadmin@vm-tomcat conf]$ sudo systemctl status tomcat.service
    ```

# Apache
- 安裝 Apache
    - `yum install httpd -y`
- 安裝 SSL tool
    - `yum install mod_ssl openssl -y`
- 產生私鑰
    - `openssl genrsa -out server.key 2048`
- 產生 CSR
    - `openssl req -new -key server.key -out server.csr`
- 產生自我簽署的金鑰 (trusted certificate)
    - `openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt`
- 複製檔案至正確位置
    - `cp server.crt /etc/pki/tls/certs`
    - `cp server.key /etc/pki/tls/p rivate/server.key`
    - `cp server.csr /etc/pki/tls/private/server.csr`
- 更新 Apache SSL 的設定檔
    - `vi +/SSLCertificateFile /etc/httpd/conf.d/ssl.conf`
        ```
        SSLCertificateFile /etc/pki/tls/certs/server.crt
        SSLCertificateKeyFile /etc/pki/tls/private/server.key
        SSLCertificateChainFile /etc/pki/tls/certs/ca_bundle.crt # 在外網需要使用

        <VirtualHost 10.0.8.4:443>
            ServerName squid.gotdns.ch:443
        </VirtualHost>
        ```
- 重啟服務
- 測試: sslshopper.com
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/security/ssl-result.png" width=500>