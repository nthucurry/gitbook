# Reference
- [Using Azure Firewall or Squid as virtual appliance in Azure Route Table to overwrite Internet outbound system route of Azure VMs](https://jasonpangazure.medium.com/how-to-use-azure-firewall-and-squid-as-virtual-appliance-in-azure-route-table-to-overwrite-debc98b8f0b8)
- [How to set up a transparent proxy on Linux](https://www.xmodulo.com/how-to-set-up-transparent-proxy-on-linux.html)

# Install squid
```bash
apt-get update
apt-get install squid
apt install net-tools
service squid status
netstat -ntl
```

# Setup squid as a transparent proxy
- `ln -s /etc/squid/squid.conf`
- `vi squid.conf`
    ```
    http_port 3128
    http_port 3129 intercept
    ```
- `apt-get install iptables`
- `iptables -t nat -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner root -j RETURN`
- `iptables -t nat -A OUTPUT -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3129`
- `iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128`
    - incoming HTTP traffic
    - 從其他機器上的外部的 IP 會發生效果
    - 從本地端發起的連線不會遵循 nat 表上 PREROUTING 鏈的設定
- `vi /etc/sysctl.conf`
    - `net.ipv4.ip_forward = 1`
    - `sysctl -p`

# Reset iptables
```bash
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
```