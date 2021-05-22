# OpenSSL
- 安裝
    - `yum install mod_ssl openssl -y`
- 產生私鑰
    - `openssl genrsa -out ca.key 2048`
- 產生 CSR
    - `openssl req -new -key ca.key -out ca.csr`
- 產生自我簽署的金鑰
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