- [參考](#參考)
- [企業憑證申請流程](#企業憑證申請流程)
- [自產憑證 (內部使用)](#自產憑證-內部使用)
- [匯入自簽憑證到「受信任的根憑證授權單位」](#匯入自簽憑證到受信任的根憑證授權單位)
- [更換憑證](#更換憑證)
- [轉換憑證格式 (有點複雜...)](#轉換憑證格式-有點複雜)
- [CentOS 7 自簽憑證](#centos-7-自簽憑證)
- [By Service](#by-service)
  - [NGINX](#nginx)
  - [Tomcat](#tomcat)
  - [Apache](#apache)

# 參考
- https://www.ionos.com/digitalguide/server/configuration/apache-tomcat-on-centos/
- https://downloads.apache.org/tomcat/tomcat-9/
- [NGINX 設定 HTTPS 網頁加密連線，建立自行簽署的 SSL 憑證](https://blog.gtwang.org/linux/nginx-create-and-install-ssl-certificate-on-ubuntu-linux/)
- [AWS：建立和簽署 X509 憑證](https://docs.aws.amazon.com/zh_tw/elasticbeanstalk/latest/dg/configuring-https-ssl.html)
- [SSL For Free](https://manage.sslforfree.com/dashboard)
- [My No-IP](https://my.noip.com/)
- [如何使用 OpenSSL 建立開發測試用途的自簽憑證 (Self-Signed Certificate)](https://blog.miniasp.com/post/2019/02/25/Creating-Self-signed-Certificate-using-OpenSSL?fbclid=IwAR1t3nxrOx--4yAHxoiGSyOi5RqvvHmm3UFCBt5bHKKritbWYBs3dwQHrVE)
- 名詞解釋
    - csr: Certificate Signing Request，證書簽名請求 (公鑰)
    - crt: 又稱 cer，為 **Cer**tificate 縮寫
    - X.509: 一種證書格式，以 **.crt** 結尾，依內容編碼格式分為兩種
        - PEM: Privacy Enhanced Mail，文字格式，以 "—–BEGIN..." 開頭、"—–END..." 結尾，常見於 Apache、Nginx
        - DER: Distinguished Encoding Rules，二進位制，常見於 Java、Windows
    - pfx: pkcs12，一種歸檔檔案格式，用來打包一個私 (private.key) 及一個 X.509 憑證 (server.cer)

# 企業憑證申請流程
1. 客戶產生後，**憑證要求檔**給憑證經銷商
    - 一次搞定 (private.key + server.csr)
        - `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout private.key -out server.csr`
    - 分次搞定
        - **私**密金**鑰**檔 (private.key)
            - `openssl genrsa -out private.key 2048`
        - 憑證要求檔 (server.csr, certificate **r**equest)
            - `openssl req -new -key private.key -out server.csr`
2. 處置完後，憑證經銷商給客戶
    - 伺服器憑證 (server.crt, 公鑰)
        - `openssl x509 -req -days 365 -in server.csr -signkey private.key -out server.crt` (失敗?)
3. 客戶合併**伺服器憑證**、**私密金鑰檔** --> server_crt-private_key.pfx (for windows)
    - `openssl pkcs12 -in server.crt -inkey private.key -export -out server_crt-private_key.pfx -password pass:1234`
4. 從 server_crt-private_key.pfx 匯出**伺服器憑證檔**、**私密金鑰檔**
    - `openssl pkcs12 -in server_crt-private_key.pfx -nokeys -password "pass:1234" -out - 2>/dev/null | openssl x509 -out server.crt`
5. 從 server_crt-private_key.pfx 匯出 **CA**
    - ~~`openssl pkcs12 -in server_crt-private_key.pfx -password "pass:1234" -nokeys -nodes -cacerts -out ca.crt`~~ (失敗?)
    - ~~`openssl pkcs12 -in server_crt-private_key.pfx -cacerts -nokeys -chain -out ca.pem`~~ (失敗?)
    - 解碼
        - `openssl pkcs12 -in server_crt-private_key.pfx -nodes -out profileinfo.txt`
6. Convert the x509 Public Certificate and CA Chain from PFX to PEM format
    - `openssl x509 -in server.crt -out server.pem`
    - `openssl x509 -in ca-pfx.pem -out ca.pem`

# 自產憑證 (內部使用)
透過 OpenSSL 工具來產生可信賴的 SSL/TLS 自簽憑證
- 安裝 OpenSSL 工具
    - `sudo yum install openssl`
- 使用 OpenSSL 建立自簽憑證
    1. 建立 **ssl.conf** 設定檔
    2. 產生自簽憑證 (server.crt) 與私密金鑰 (server.key)
        - `openssl req -x509 -new -nodes -sha256 -utf8 -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt -config ssl.conf`
    3. 產生 PKCS#12 憑證檔案 (*.pfx 或 *.p12)
        - `openssl pkcs12 -export -in server.crt -inkey server.key -out server.pfx`
    4. 如此以來，你就擁有三個檔案，分別是
        1. server.key (私密金鑰) (使用 PEM 格式) (無密碼保護)
        2. server.crt (憑證檔案) (使用 PEM 格式)
        3. server.pfx (PFX 檔案) (使用 PKCS#12 格式) (有密碼保護)

# 匯入自簽憑證到「受信任的根憑證授權單位」
光是建立好自簽憑證，網站伺服器也設定正確，還是不夠的。這畢竟是一個 PKI 基礎架構，必須所有需要安全連線的端點都能互相信任才行，因此你還必須將建立好的自簽憑證安裝到「受信任的根憑證授權單位」之中，這樣子你的作業系統或瀏覽器才能將你的自簽憑證視為「可信任的連線」

# 更換憑證
- `openssl pkcs12 -in xxx.pfx -password "pass:xxx" -nokeys -out server.crt`
    - `SSLCertificateFile /etc/httpd/conf/ssl/server.crt`
- `openssl pkcs12 -in xxx.pfx -password "pass:xxx" -nodes -nocerts -out private.key`
    - `SSLCertificateKeyFile /etc/httpd/conf/ssl/private.key`
- `openssl pkcs12 -in xxx.pfx -password "pass:xxx" -nokeys -nodes -cacerts -out ca.crt`
    - `SSLCACertificateFile /etc/httpd/conf/ssl/ca.crt`
- `systemctl restart httpd`


# 轉換憑證格式 (有點複雜...)
```bash
# crt 轉成 cer (DER 編碼二進制格式)
openssl x509 -in cert.pem -out FindARTs.der -outform der

openssl x509 -in FindARTs.der -out FindARTs.cer -inform DER
openssl pkcs12 -in FindARTs.cer -inkey privkey.pem -export -out FindARTs.pfx -password pass:1234
# cer 轉成 crt (DER 編碼二進制格式)
openssl x509 -in server.cer -out server2.crt -inform DER

openssl pkcs12 -in cert.pem -inkey privkey.pem -export -out FindARTs.pfx -password pass:1234
```

# CentOS 7 自簽憑證
- 產生自簽憑證
    - 私密金鑰檔：`openssl genrsa -out private.key 2048`
    - 憑證要求檔：`openssl req -new -key private.key -out server.csr`
    - 伺服器憑證：`openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout private.key -out server.crt`
    - 合併金鑰檔：`openssl pkcs12 -export -out server.pfx -inkey private.key -in server.crt`
- 顯示證書詳細訊息
    - `openssl x509 -in certificate.crt -text -noout`
- `openssl x509 -inform DES -in checkmarx.pfx -out checkmarx.pem -text`
- `cat checkmarx.pem >> /etc/pki/tls/certs/ca-bundle.crt`

# By Service
## NGINX
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
    - `openssl pkcs12 -export -out nginx-server.pfx -inkey nginx-private.key -in nginx-server.crt`

## Tomcat
- [Tomcat7 升級 Https](https://medium.com/@eliu01011/tomcat7-%E5%8D%87%E7%B4%9A-https-with-lets-encrypt-29ea499730f9)
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

## Apache
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