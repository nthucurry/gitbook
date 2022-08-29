# Refencerce
- [Firewalld 防火牆配置 CentOS7](https://lab.twidc.net/centos7-%E9%98%B2%E7%81%AB%E7%89%86-firewall-cmd-firewalld/)
- [在 CentOS 7 使用 firewalld 架設 NAT](https://itopnet.blogspot.com/2019/04/centos-7-firewalld-nat.html)

# 使用 port forwarding
- To forwards traffic from port 80 to port 3128 on the same server
    - `firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=3128`
- To forward a port to a different server
    - `firewall-cmd --zone=public --add-masquerade`
    - `firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=3128:toaddr=10.1.0.7`

# 使用 firewalld [ipset](https://www.cnblogs.com/architectforest/p/12973982.html) 控管 host name (未完成...)
- `firewall-cmd --permanent --new-ipset=whitelist --type=hash:ip`
    - `ipset create whitelist hash:ip`
- 確認檔案是否產生
        - `cat /etc/firewalld/ipsets/whitelist.xml`
- `firewall-cmd --permanent --ipset=whitelist --add-entry=34.117.59.81`
- `firewall-cmd --permanent --info-ipset=whitelist`
- `vi whitelist.sh`
    ```bash
    cat $HOME/whitelist.list | while read fqdn
    do
      ip=`dig +short $fqdn`
      ipset flush whitelist
      ipset add whitelist $ip
    done
    ```
- `ipset list whitelist`
- Allow all IPv4 traffic from host 192.0.2.0
    - `firewall-cmd --zone=public --add-rich-rule 'rule family=ipv4 source address=192.0.2.0 accept'`
- `firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -m set --match-set whitelist src -j ACCEPT`
- `crontab -e`
    ```
    */5 * * * * /root/whitelist.sh
    ```
- `firewall-cmd --reload`
- `firewall-cmd --runtime-to-permanent`

# 重設 firewalld
```bash
for srv in $(firewall-cmd --list-services);
do
  firewall-cmd --remove-service=$srv;
done
firewall-cmd --add-service={ssh,dhcpv6-client}
firewall-cmd --runtime-to-permanent
```

# 限制 outbound 存取
```bash
firewall-cmd --direct --add-rule ipv4 filter OUTPUT 0 -d 13.76.158.163/32 -j REJECT
```