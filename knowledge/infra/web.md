# Web Service
## 參考
- https://www.ionos.com/digitalguide/server/configuration/apache-tomcat-on-centos/
- https://downloads.apache.org/tomcat/tomcat-9/
- http://ftp.tc.edu.tw/pub/Apache/tomcat/tomcat-9/v9.0.44/bin/

## Tomcat
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
    - `openssl genrsa -out ca.key 2048`
- 產生 CSR
    - `openssl req -new -key ca.key -out ca.csr`
- 產生自我簽署的金鑰 (trusted certificate)
    - `openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt`
- 複製檔案至正確位置
    - `cp ca.crt /etc/pki/tls/certs`
    - `cp ca.key /etc/pki/tls/private/ca.key`
    - `cp ca.csr /etc/pki/tls/private/ca.csr`
- 更新 Apache SSL 的設定檔
    - `vi +/SSLCertificateFile /etc/httpd/conf.d/ssl.conf`
        ```
        SSLCertificateFile /etc/pki/tls/certs/ca.crt
        SSLCertificateKeyFile /etc/pki/tls/private/ca.key

        <VirtualHost 10.0.8.4:443>
            ServerName squid.hopto.org:443
        </VirtualHost>
        ```
- 重啟 apache 服務
- 測試: sslshopper.com
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/security/ssl-result.png">