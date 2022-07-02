# Reference
- [Installing Guacamole natively](https://guacamole.apache.org/doc/1.4.0/gug/installing-guacamole.html)
- [Deploying Guacamole](https://guacamole.apache.org/doc/gug/installing-guacamole.html#deploying-guacamole)
- [Using the default authentication](https://guacamole.apache.org/doc/1.4.0/gug/configuring-guacamole.html#basic-auth)

# [Apache Guacamole 1.1.0 Install Guide](https://www.byteprotips.com/post/apache-guacamole-1-1-0-install-guide)
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
    - `wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-8.0.28.tar.gz`
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
    ```properties
    # MySQL properties
    mysql-hostname: localhost
    mysql-port: 3306
    mysql-database: guacdb
    mysql-username: guacuser
    mysql-password: guacpass

    # Additional settings
    mysql-default-max-connections-per-user: 0
    mysql-default-max-group-connections-per-user: 0
    ```
- Fix some file permissions
    - `chown tomcat:tomcat /etc/guacamole/guacamole.properties`
    - `ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat/.guacamole/`
    - `chown tomcat:tomcat /var/lib/tomcat/webapps/guacamole.war`
- Fix a permission issue with SELinux
    - `setsebool -P tomcat_can_network_connect_db on`
    - `restorecon -R -v /usr/share/tomcat/.guacamole/lib/mysql-connector-java-8.0.26.jar`
- Start Guacamole
    - `systemctl enable guacd --now`
- Finish
    - 帳/密: guacadmin/guacadmin
    - URL: http://t-rdp.southeastasia.cloudapp.azure.com:8080/guacamole
- Change the port of Tomcat from 8080 to 80
    ```bash
    echo "iptables -t nat -A PREROUTING -p tcp --dport  80 -j REDIRECT --to-port 8080" >> /etc/rc.local
    echo "iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443" >> /etc/rc.local
    ```

## Add Certification (SSL for Test)
- 註冊
    ```bash
    TOMCAT_HOME=/usr/share/tomcat
    mkdir -p $TOMCAT_HOME/webapps/.well-known/pki-validation
    ```
- `mkdir /etc/ssl/private`
- `vi /etc/tomcat/service.xml`
    ```xml
    <Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol"
            maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
            clientAuth="false" sslProtocol="TLS">
        <SSLHostConfig>
            <Certificate certificateKeyFile="/etc/ssl/private/private_ssl4free.key" certificateFile="/etc/ssl/certs/certificate_ssl4free.crt" certificateChainFile="/etc/ssl/certs/ca_bundle_ssl4free.crt" type="RSA" />
        </SSLHostConfig>
    </Connector>
    ```

# Check Service Status
```bash
systemctl status tomcat
systemctl status mariadb
systemctl status guacd
```

# [Apache Guacamole with Azure AD using SAML](https://sintax.medium.com/apache-guacamole-with-azure-ad-using-saml-5d890c7e08bf)
- `wget https://archive.apache.org/dist/guacamole/1.3.0/binary/guacamole-auth-saml-1.3.0.tar.gz`
- `tar -zxf guacamole-auth-saml-1.3.0.tar.gz`
- `cp guacamole-auth-saml-1.3.0/guacamole-auth-saml-1.3.0.jar /usr/share/tomcat/.guacamole/extensions/`

# [Installing Guacamole natively](https://guacamole.apache.org/doc/1.4.0/gug/installing-guacamole.html)

# [Configuring Guacamole](https://guacamole.apache.org/doc/gug/configuring-guacamole.html#configuring-guacamole)