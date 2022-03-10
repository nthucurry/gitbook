# Azure Load Balancer components
## Frontend IP
<br><img src="https://docs.microsoft.com/en-us/azure/load-balancer/media/load-balancer-overview/load-balancer.png">

## Backend pool
## Health probes
## Load Balancer rules
<br><img src="https://docs.microsoft.com/en-us/azure/load-balancer/media/load-balancer-components/lbrules.png" width=600>

- On Azure, Floating IP should enable
    <br><img src="https://docs.microsoft.com/en-us/azure/load-balancer/media/load-balancer-multivip-overview/load-balancer-multivip-dsr.png">
- On OS, [Floating IP Guest OS configuration](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-floating-ip#floating-ip-guest-os-configuration)
    - [Linux 绑定 IP 与 net.ipv4.ip_nonlocal_bind 不存在](https://www.igiftidea.com/article/11556082942.html)
    - 設定 IP forward 和 bind 不存在的 IP
        ```bash
        echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
        echo net.ipv4.ip_nonlocal_bind=1 >> /etc/sysctl.conf
        sysctl -p
        ```
    - [安裝流量监控](https://www.geeksforgeeks.org/how-to-install-nload-in-linux/)
        ```bash
        yum install epel-release -y
        yum install iftop -y
        ```
    - [設定 reverse proxy](https://www.maxlist.xyz/2020/06/18/flask-nginx/)
        - `yum install nginx -y`
        - `systemctl start nginx.service; systemctl enable nginx.service`
        - `nginx -t`
            - 檢查格式
        - `nginx -s reload`
            - 參數 reload 後生效
        - `vi /etc/nginx/nginx.conf`
            ```conf
            listen       80;
            server_name  t-web.southeastasia.cloudapp.azure.com;
            location / {
                proxy_pass http://t-web:80/;
                #index index.html index.htm;
            } # end location
            ```