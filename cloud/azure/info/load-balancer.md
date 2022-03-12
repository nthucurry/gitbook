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
        - `tcpdump | grep -vE "168.63.129.16|169.254.169.254|https" | grep http`
            - IP t-nva.internal.cloudapp.net.50558 > t-web.internal.cloudapp.net.http: Flags [S], seq 3988095674, win 29200, options [mss 1460,sackOK,TS val 3183275 ecr 0,nop,wscale 7], length 0
            - IP t-web.internal.cloudapp.net.http > t-nva.internal.cloudapp.net.50558: Flags [S.], seq 742088775, ack 3988095675, win 28960, options [mss 1418,sackOK,TS val 2635803 ecr 3183275,nop,wscale 7], length 0
            - IP t-nva.internal.cloudapp.net.50558 > t-web.internal.cloudapp.net.http: Flags [.], ack 1, win 229, options [nop,nop,TS val 3183276 ecr 2635803], length 0
            - IP t-nva.internal.cloudapp.net.50558 > t-web.internal.cloudapp.net.http: Flags [P.], seq 1:70, ack 1, win 229, options [nop,nop,TS val 3183277 ecr 2635803], length 69: HTTP: GET / HTTP/1.1
            - IP t-web.internal.cloudapp.net.http > t-nva.internal.cloudapp.net.50558: Flags [.], ack 70, win 227, options [nop,nop,TS val 2635804 ecr 3183277], length 0
            - IP t-web.internal.cloudapp.net.http > t-nva.internal.cloudapp.net.50558: Flags [P.], seq 1:246, ack 70, win 227, options [nop,nop,TS val 2635804 ecr 3183277], length 245: HTTP: HTTP/1.1 200 OK
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
                proxy_pass http://t-web;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                #index index.html index.htm;
            }
            ```
    - [設定 iptables](http://www.noobyard.com/article/p-urmalkcy-t.html)
        - `vi /etc/sysconfig/iptables`
    - [設定 loopback address](https://leoprosoho.pixnet.net/blog/post/27398897)
        ```conf
        DEVICE=lo
        IPADDR=127.0.0.1
        NETMASK=255.0.0.0
        NETWORK=127.0.0.0
        BROADCAST=127.255.255.255
        ONBOOT=yes
        NAME=loopback

        DEVICE=lo:1
        IPADDR=10.1.87.100
        NETMASK=255.255.255.0
        NETWORK=10.1.87.0
        BROADCAST=10.1.87.255
        ONBOOT=yes
        NAME=loopback1
        ```
        - systemctl restart network