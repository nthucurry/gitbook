# Transparent Proxy
- https://maple52046.github.io/posts/setup-squid-transparent-proxy-with-docker/
- 設定 IP Forwarding
    ```bash
    echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
    sysctl -p
    ```
- 轉 port
    ```bash
    firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=3128
    firewall-cmd --add-masquerade
    firewall-cmd --runtime-to-permanent
    firewall-cmd --list-all
    ```
- [Firewall rules based on Domain name instead of IP address](https://unix.stackexchange.com/questions/557388/firewall-rules-based-on-domain-name-instead-of-ip-address)
    ```bash
    firewall-cmd --permanent --new-ipset=sshblock --type=hash:

    # 建立 ipset 規則
    ipset create whitelist hash:ip

    # 加入白名單 IP
    ipset add whitelist 192.168.0.5

    # 建立 firewall 規則
    iptables -A INPUT -p tcp --dport 3128 -m set --match-set whitelist src -j ACCEPT

    firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -m set --match-set whitelist src -j DROP
    ```
- `tcpdump | grep -Ev "111-249-66-125|168.63.129.16|ssh"`
    ```
    16:15:17.787944 IP t-rdp.internal.cloudapp.net.57474 > 81.59.117.34.bc.googleusercontent.com.http: Flags [S], seq 3174276358, win 29200, options [mss 1418,sackOK,TS val 19980427 ecr 0,nop,wscale 7], length 0
    16:15:17.788010 IP t-squid.internal.cloudapp.net.57474 > 81.59.117.34.bc.googleusercontent.com.squid: Flags [S], seq 3174276358, win 29200, options [mss 1418,sackOK,TS val 19980427 ecr 0,nop,wscale 7], length 0
    16:15:17.791962 IP 81.59.117.34.bc.googleusercontent.com.squid > t-squid.internal.cloudapp.net.57474: Flags [R.], seq 0, ack 3174276359, win 0, length 0
    16:15:17.791975 IP 81.59.117.34.bc.googleusercontent.com.http > t-rdp.internal.cloudapp.net.57474: Flags [R.], seq 0, ack 3174276359, win 0, length 0
    ```
- nat
    ```
    sysctl -p
    sysctl -w net.ipv4.ip_forward=1
    sysctl -w net.ipv6.conf.all.forwarding=1
    sysctl -w net.ipv4.conf.all.send_redirects=0`
    ```
- iptables
    ```bash
    # -t: 使用 NAT table
    # -A: 新增 OUTPUT 規則
    # -p: 走 tcp 協定
    # -d: 目標為 80 port
    # -j: 後續動作為 return
    iptables -t nat -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner root -j RETURN
    iptables -t nat -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner squid -j RETURN

    iptables -t nat -A PREROUTING -s 10.0.0.0/8 -p tcp --dport 80 -j REDIRECT --to-port 3128
    iptables -t nat -A PREROUTING -s 10.0.0.0/8 -p tcp --dport 443 -j REDIRECT --to-port 3129

    # iptables -t nat -A OUTPUT -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3129
    ```
- squid.conf
    ```
    acl allowurl url_regex -i "/etc/squid/allow_url.lst"
    http_access deny !allowurl
    http_access allow allowurl

    http_access allow localnet
    http_access allow localhost
    http_access deny all

    http_port 3128
    http_port 3129 intercept
    ```