# Reference
- [Guacamole for AWS (SAML 2.0)](https://docs.netcubed.io/products/guacamole/authentication/saml/)
- [Guacamole Integration with AuthPoint](https://www.watchguard.com/help/docs/help-center/en-US/Content/Integration-Guides/AuthPoint/Guacamole_saml_authpoint.html)
- [针对 Active Directory 的 Apache Guacamole 身份验证](https://www.bujarra.com/autenticacion-de-apache-guacamole-contra-directorio-activo/?lang=zh)
- [Guacamole RDP won't connect](https://stackoverflow.com/questions/68458381/guacamole-rdp-wont-connect)
- [ubuntu 安装 guacamole 远程 windows 指导书_胡同老道的博客-程序员 ITS401](https://its401.com/article/obana/121003969)

# [Apache Guacamole 1.1.0 Install Guide](https://www.byteprotips.com/post/apache-guacamole-1-1-0-install-guide)
- Environment Variable
    ```bash
    GUACAMOLE_HOME=/etc/guacamole
    ```
- Enable the Enterprise Linux Repositories (EPEL)
    - `yum install epel-release -y`
    - `yum update -y`
- Install ffmpeg-devel package (that package is not included with the base CentOS or EPEL repositories)
    - `rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro`
    - `rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm`
- Install several dependencies
    - `yum install cairo-devel libjpeg-turbo-devel libwebsockets-devel libpng-devel uuid-devel ffmpeg-devel freerdp-devel pango-devel libssh2-devel libvncserver-devel pulseaudio-libs-devel openssl-devel libvorbis-devel libwebp-devel libtool libtelnet-devel freerdp mariadb-server wget tomcat -y`
- Download Guacamole server source code (.tar.gz) & Web Application (.war)
    - `wget https://downloads.apache.org/guacamole/1.4.0/source/guacamole-server-1.4.0.tar.gz`
    - `tar -xzf guacamole-server-1.4.0.tar.gz`
    - `wget https://downloads.apache.org/guacamole/1.4.0/binary/guacamole-1.4.0.war`
- Compiling and installation
    - `cd guacamole-server-1.4.0/`
    - `./configure --with-init-dir=/etc/init.d`
    - `make`
    - `make install`
    - `ldconfig`
- Copy to the correct directory
    - `cp guacamole-1.4.0.war /var/lib/tomcat/webapps/guacamole.war`
- Configure Guacamole to support multiple users and connections (by MySQL)
    - `mkdir -p /usr/share/tomcat/.guacamole/{extensions,lib}`
    - `wget https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-8.0.28.tar.gz`
    - `tar -zxf mysql-connector-java-8.0.28.tar.gz`
    - `cp mysql-connector-java-8.0.28/mysql-connector-java-8.0.28.jar /usr/share/tomcat/.guacamole/lib/`
    - `wget https://downloads.apache.org/guacamole/1.4.0/binary/guacamole-auth-jdbc-1.4.0.tar.gz`
    - `tar zxf guacamole-auth-jdbc-1.4.0.tar.gz`
    - `cp guacamole-auth-jdbc-1.4.0/mysql/guacamole-auth-jdbc-mysql-1.4.0.jar /usr/share/tomcat/.guacamole/extensions/`
- Start mariadb and tomcat
    - `systemctl enable tomcat --now`
    - `systemctl enable mariadb --now`
- Secure our mysql/mariadb installation
    - `mysql_secure_installation` (照著設定)
        - Enter current password for root (enter for none): enter
        - Set root password? [Y/n] n
        - Remove anonymous users? [Y/n] Y
        - Disallow root login remotely? [Y/n] Y
        - Remove test database and access to it? [Y/n] Y
        - Reload privilege tables now? [Y/n] Y
- Configure the tables and database scheme
    - `mysql -u root -p`
    - `CREATE DATABASE IF NOT EXISTS guacdb DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;`
    - `GRANT SELECT,INSERT,UPDATE,DELETE ON guacdb.* TO 'guacuser'@'localhost' IDENTIFIED BY 'guacpass' WITH GRANT OPTION;`
    - `flush privileges;`
    - `quit`
- Configure Guacamole client
    - `wget https://downloads.apache.org/guacamole/1.4.0/source/guacamole-client-1.4.0.tar.gz`
    - `tar -zxf guacamole-client-1.4.0.tar.gz`
    - `cat guacamole-client-1.4.0/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/*.sql | mysql -u root -p guacdb`
- Create the Guacamole configuration file
    - `mkdir -p /etc/guacamole`
    - `vi /etc/guacamole/guacamole.properties`
- Paste the following into the file
    ```
    # MySQL properties
    mysql-hostname: localhost
    mysql-port: 3306
    mysql-database: guacdb
    mysql-username: guacuser
    mysql-password: guacpass

    # Additional settings
    mysql-default-max-connections-per-user: 0
    mysql-default-max-group-connections-per-user: 0

    # Hostname and port of guacamole proxy
    guacd-hostname: localhost
    guacd-port:     4822

    #basic-user-mapping: /etc/guacamole/user-mapping.xml
    #user-mapping: /etc/guacamole/user-mapping.xml
    ```
- Fix some file permissions
    - `chown tomcat:tomcat /etc/guacamole/guacamole.properties`
    - `chown tomcat:tomcat /var/lib/tomcat/webapps/guacamole.war`
    - `ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat/.guacamole/`
    - `touch /etc/guacamole/guacd.conf`
    - `touch /etc/guacamole/logback.xml`
    - `touch /etc/guacamole/user-mapping.xml`
    - `ln -s /etc/guacamole/guacd.conf /usr/share/tomcat/.guacamole/`
    - `ln -s /etc/guacamole/logback.xml /usr/share/tomcat/.guacamole/`
    - `ln -s /etc/guacamole/user-mapping.xml /usr/share/tomcat/.guacamole/`
- Fix a permission issue with SELinux
    - `setsebool -P tomcat_can_network_connect_db on`
    - `restorecon -R -v /usr/share/tomcat/.guacamole/lib/mysql-connector-java-8.0.28.jar`
- Start Guacamole
    - `systemctl enable guacd --now`
- Finish
    - 帳/密: guacadmin/guacadmin
    - URL: http://t-rdp.southeastasia.cloudapp.azure.com:8080/guacamole
- Change the port of Tomcat from 8080 to 80
    ```bash
    echo "iptables -t nat -A PREROUTING -p tcp --dport  80 -j REDIRECT --to-port 8080" >> /etc/rc.local
    echo "iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443" >> /etc/rc.local
    chmod +x /etc/rc.d/rc.local
    ```
- Download a font for linux (ex: font-name: DroidSansMono)
    - `yum install google-droid-sans-mono-fonts -y`

## Add Certification (SSL for Test)
- 註冊
    ```bash
    TOMCAT_HOME=/usr/share/tomcat
    mkdir -p $TOMCAT_HOME/webapps/.well-known/pki-validation
    vi $TOMCAT_HOME/webapps/.well-known/pki-validation/test.html
    ```
- 取得憑證
    - ca_bundle(_ssl4free).crt
    - certificate.crt
    - private.key
- `mkdir /etc/ssl/private`
- 複製憑證
    ```bash
    cp ca_bundle.crt /etc/ssl/certs/ca_bundle_ssl4free.crt
    cp certificate.crt /etc/ssl/certs/
    cp private.key /etc/ssl/private/
    ```
- `cd /etc/ssl/certs`
    ```bash
    openssl pkcs12 -export \
        -out "/etc/ssl/certs/certificate.pfx" \
        -inkey "/etc/ssl/private/private.key" \
        -in "/etc/ssl/certs/certificate.crt" \
        -certfile "/etc/ssl/certs/ca_bundle_ssl4free.crt"
    # 123456
    ```
    ```bash
    keytool -importkeystore \
        -srckeystore "/etc/ssl/certs/certificate.pfx" \
        -srcstorepass 123456 \
        -srcstoretype pkcs12 \
        -destkeystore "/etc/ssl/certs/certificate.jks" \
        -deststoretype pkcs12 \
        -deststorepass 123456
    ```
- `vi /etc/tomcat/server.xml`
    ```xml
    <Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol"
               maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS"
               keystoreFile="/etc/ssl/certs/certificate.jks" keystorePass="123456"
               ciphers="TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" />
    ```
- `systemctl restart tomcat`
- `tail -100f /var/log/tomcat/catalina.2022-07-02.log`

## [Tomcat 配置 https 協議、以及 http 協議自動 REDIRECT 到 HTTPS](https://www.796t.com/content/1546493424.html)
- 在 /usr/share/tomcat/conf/web.xml 中的 <\/welcome-file-list> 後面加上這樣一段
    ```xml
    <login-config>

        <!-- Authorization setting for SSL -->
        <auth-method>CLIENT-CERT</auth-method>
        <realm-name>Client Cert Users-only Area</realm-name>

    </login-config>
    <security-constraint>

        <!-- Authorization setting for SSL -->
        <web-resource-collection >
            <web-resource-name >SSL</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <user-data-constraint>
            <transport-guarantee>CONFIDENTIAL</transport-guarantee>
        </user-data-constraint>

    </security-constraint>
    ```

# Check Service Status
```bash
systemctl status tomcat mariadb guacd | grep Active
```

# Create SAML SSO Enterprise Application
- Basic SAML Configuration
    - Identifier (Entity ID): **https://t-rdp.southeastasia.cloudapp.azure.com/guacamole**
    - Reply URL (Assertion Consumer Service URL): **https://t-rdp.southeastasia.cloudapp.azure.com/guacamole**
- SAML Signing Certificate
    - App Federation Metadata Url: https://login.microsoftonline.com/[Tenant ID]/federationmetadata/2007-06/federationmetadata.xml?appid=[Application ID]
-  Set up Apache Guacamole SAML SSO
    -  Login URL: https://login.microsoftonline.com/[Tenant ID]/saml2

# [Apache Guacamole with Azure AD using SAML](https://sintax.medium.com/apache-guacamole-with-azure-ad-using-saml-5d890c7e08bf)
- `wget https://archive.apache.org/dist/guacamole/1.4.0/binary/guacamole-auth-sso-1.4.0.tar.gz`
- `tar -zxf guacamole-auth-sso-1.4.0.tar.gz`
- `cp guacamole-auth-sso-1.4.0/saml/guacamole-auth-sso-saml-1.4.0.jar /usr/share/tomcat/.guacamole/extensions/`
- `vi /etc/guacamole/guacamole.properties`
    ```
    # SAML
    #skip-if-unavailable: saml
    saml-idp-url: https://login.microsoftonline.com/[Tenant ID]/saml2
    saml-entity-id: https://t-rdp.southeastasia.cloudapp.azure.com/guacamole
    saml-callback-url: https://t-rdp.southeastasia.cloudapp.azure.com/guacamole
    saml-idp-metadata-url: https://login.microsoftonline.com/[Tenant ID]/federationmetadata/2007-06/federationmetadata.xml?appid=[Application ID]
    saml-debug: true
    extension-priority: mysql, saml
    ```
- 設定好後登入 https://t-rdp.southeastasia.cloudapp.azure.com/guacamole
    - 沒有 SAML SSO 權限
        ```
        AADSTS50105: Your administrator has configured the application Apache Guacamole SAML SSO ('<Application ID>') to block users unless they are specifically granted ('assigned') access to the application. The signed in user 'XXX@XXX.onmicrosoft.com' is blocked because they are not a direct member of a group with access, nor had access directly assigned by an administrator. Please contact your administrator to assign access to this application.
        ```
    - 不在 AAD 內的帳號登入
        ```
        AADSTS50020: User account 'XXX@hotmail.com' from identity provider 'live.com' does not exist in tenant 'AUO Corporation' and cannot access the application 'https://t-rdp.southeastasia.cloudapp.azure.com'(Apache Guacamole SAML SSO) in that tenant. The account needs to be added as an external user in the tenant first. Sign out and sign in again with a different Azure Active Directory user account.
        ```
    - URL suffix 要加上 guacamole
        ```
        AADSTS50011: The reply URL 'https://t-rdp.southeastasia.cloudapp.azure.com/api/ext/saml/callback' specified in the request does not match the reply URLs configured for the application 'https://t-rdp.southeastasia.cloudapp.azure.com'. Make sure the reply URL sent in the request matches one added to your application in the Azure portal. Navigate to https://aka.ms/urlMismatchError to learn more about how to fix this.
        ```
- `systemctl restart tomcat guacd`
- `tail -100f /var/log/messages`

# [Configuring Guacamole](https://guacamole.apache.org/doc/gug/configuring-guacamole.html#configuring-guacamole)
- `vi /usr/share/tomcat/.guacamole/logback.xml`
    ```xml
    <configuration>

        <!-- Appender for debugging -->
        <appender name="GUAC-DEBUG" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>

        <!-- Log at DEBUG level -->
        <root level="debug">
            <appender-ref ref="GUAC-DEBUG"/>
        </root>

    </configuration>
    ```
- `vi /etc/guacamole/guacd.conf`
    ```
    [daemon]
    pid_file=/var/run/guacd.pid
    log_level=info

    [server]
    bind_host=127.0.0.1
    bind_port=4822
    ```
- ~~`vi /usr/share/tomcat/.guacamole/user-mapping.xml`~~ (not sure)
    ```xml
    <user-mapping>

        <!-- Per-user authentication and config information -->
        <authorize username="USERNAME" password="PASSWORD">
            <protocol>ssh</protocol>
            <param name="hostname">10.1.86.6</param>
            <param name="port">22</param>
            <param name="password">VNCPASS</param>
            <param name="ignore-cert">true</param>
        </authorize>

        <!-- Per-user authentication and config information -->
        <authorize username="USERNAME" password="PASSWORD">
            <protocol>vnc</protocol>
            <param name="hostname">localhost</param>
            <param name="port">5900</param>
            <param name="password">VNCPASS</param>
        </authorize>

        <!-- Another user, but using md5 to hash the password
            (example below uses the md5 hash of "PASSWORD") -->
        <authorize
                username="USERNAME2"
                password="319f4d26e3c536b5dd871bb2c52e3178"
                encoding="md5">

            <!-- First authorized connection -->
            <connection name="localhost">
                <protocol>vnc</protocol>
                <param name="hostname">localhost</param>
                <param name="port">5901</param>
                <param name="password">VNCPASS</param>
            </connection>

            <!-- Second authorized connection -->
            <connection name="otherhost">
                <protocol>vnc</protocol>
                <param name="hostname">otherhost</param>
                <param name="port">5900</param>
                <param name="password">VNCPASS</param>
            </connection>

        </authorize>

    </user-mapping>
    ```

# Troubleshooting
- RDP server closed/refused connection: SSL/TLS connection failed (untrusted/self-signed certificate?)
    <br><img src="../img/guacamole/rdp-unknown-certificate.png" width=300>
- [RDP server closed/refused connection: Server refused connection (wrong security type?)](https://stackoverflow.com/questions/44039126/guacamole-windows-10-rdp-failed)
    <br><img src="../img/guacamole/rdp-wrong-security-type.png" width=500>
- Creation of WebSocket tunnel to guacd failed: java.net.ConnectException: Connection refused (Connection refused)
    - 需設定 /etc/guacamole/guacd.conf