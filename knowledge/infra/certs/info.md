# 參考
- [如何使用 OpenSSL 建立開發測試用途的自簽憑證 (Self-Signed Certificate)](https://blog.miniasp.com/post/2019/02/25/Creating-Self-signed-Certificate-using-OpenSSL?fbclid=IwAR1t3nxrOx--4yAHxoiGSyOi5RqvvHmm3UFCBt5bHKKritbWYBs3dwQHrVE)

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
- `openssl pkcs12 -in xxx.pfx -password “pass:xxx” -nokeys -out server.crt`
    - `SSLCertificateFile /etc/httpd/conf/ssl/server.crt`
- `openssl pkcs12 -in xxx.pfx -password “pass:xxx” -nodes -nocerts -out private.key`
    - `SSLCertificateKeyFile /etc/httpd/conf/ssl/private.key`
- `openssl pkcs12 -in xxx.pfx -password “pass:xxx” -nokeys -nodes -cacerts -out ca.crt`
    - `SSLCACertificateFile /etc/httpd/conf/ssl/ca.crt`
- `systemctl restart httpd`