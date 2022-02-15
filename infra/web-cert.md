- [參考](#參考)
- [Tomcat](#tomcat)
- [Apache](#apache)

# 參考
- https://www.ionos.com/digitalguide/server/configuration/apache-tomcat-on-centos/
- https://downloads.apache.org/tomcat/tomcat-9/
- http://ftp.tc.edu.tw/pub/Apache/tomcat/tomcat-9/v9.0.44/bin/
- 第三方認證: https://manage.sslforfree.com/dashboard

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
    - `cp server.key /etc/pki/tls/private/server.key`
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
- 重啟 apache 服務
- 測試: sslshopper.com
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/security/ssl-result.png" width=500>