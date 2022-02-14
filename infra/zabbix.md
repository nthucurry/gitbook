- [Update and Install Package](#update-and-install-package)
    - [Update repo](#update-repo)
    - [Install Package](#install-package)
- [Step](#step)
- [Template](#template)
- [如果要修改參數](#如果要修改參數)

## Reference
- [1-1.監控工具之一:Zabbix Server](https://ithelp.ithome.com.tw/articles/10190611)
- [CentOS 7 使用 YUM 安裝升級 MariaDB 到指定新版本](https://www.footmark.info/linux/centos/centos7-yum-update-mariadb/)
- https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-zabbix-to-securely-monitor-remote-servers-on-centos-7
- https://www.zabbix.com/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=apache

# Update and Install Package
## Update repo
- `vi /etc/yum.repos.d/MariaDB.repo`
    ```
    [mariadb]
    name = MariaDB
    baseurl = http://yum.mariadb.org/10.4/centos7-amd64
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1
    ```
- `vi /etc/yum.repos.d/zabbix.repo`
    ```
    enabled=1
    ```

## Install Package
```bash
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
rpm -Uvh zabbix-release-5.0-1.el7.noarch.rpm

yum install zabbix-server-mysql zabbix-agent -y
yum install centos-release-scl -y
yum install zabbix-web-mysql-scl zabbix-apache-conf-scl -y
yum install mariadb mariadb-server -y
yum install httpd -y
yum install php-bcmath php-mbstring php-xml curl curl-devel net-snmp net-snmp-devel net-snmp-utils perl-DBI -y
```

# Step
- server
    - `mysql -uroot -p`
    - 直接按 enter
    - MariaDB [(none)]>
        ```sql
        create database zabbix character set utf8 collate utf8_bin;
        create user zabbix@localhost identified by 'manager1';
        grant all privileges on zabbix.* to zabbix@localhost;
        quit;
        ```
    - `zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix`
        - 輸入密碼: manager1
    - `vi /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf`
        ```
        php_value[date.timezone] = Asia/Taipei
        ```
    - 設定參數
    - 預設帳密: Admin/zabbix
- agent
    - `yum install zabbix-agent -y`
    - `vi /etc/zabbix/zabbix_agentd.conf`
        ```
        Server=[zabbix_server_ip]
        ```
    - `systemctl enable zabbix-agent`
    - `systemctl restart zabbix-agent`

# Template
- SQL Server template: https://share.zabbix.com/databases/microsoft-sql-server/template-for-microsoft-sql-server

# 如果要修改參數
- http://[zabbix_server_ip]/zabbix/setup.php