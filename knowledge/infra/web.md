# Web
## 參考
- https://www.ionos.com/digitalguide/server/configuration/apache-tomcat-on-centos/
- https://downloads.apache.org/tomcat/tomcat-9/
- http://ftp.tc.edu.tw/pub/Apache/tomcat/tomcat-9/v9.0.44/bin/

## Tomcat
    ```bash
    yum install tomcat
    yum install tomcat-webapps tomcat-admin-webapps tomcat-docs-webapp tomcat-javadoc
    systemctl start tomcat
    systemctl enable tomcat
    ```