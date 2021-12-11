# necessary config & script
cd /root
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/elk/etc/logstash/conf.d/fb-aad-audit.conf
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/elk/etc/logstash/conf.d/fb-azure-nsg-flow.conf
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/elk/etc/logstash/conf.d/fb-azure-storage-audit.conf
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/elk/etc/logstash/conf.d/fb-m365-office-activity.conf
chmod +x *.sh

# environment varible
echo "alias sre='systemctl restart elasticsearch.service'" >> /etc/bashrc
echo "alias sse='systemctl status elasticsearch.service'" >> /etc/bashrc
echo "alias srk='systemctl restart kibana.service'" >> /etc/bashrc
echo "alias ssk='systemctl status kibana.service'" >> /etc/bashrc
echo "alias srl='systemctl restart logstash.service'" >> /etc/bashrc
echo "alias ssl='systemctl status logstash.service'" >> /etc/bashrc
echo "alias srf='systemctl restart filebeat.service'" >> /etc/bashrc
echo "alias ssf='systemctl status filebeat.service'" >> /etc/bashrc
echo "alias vi='vim'" >> /etc/bashrc
echo "PATH=$PATH:/usr/share/logstash/bin" >> /etc/bashrc
echo "export LS_JAVA_OPTS=\"-Dhttp.proxyHost=squid.gotdns.ch -Dhttp.proxyPort=3128\"" >> /etc/bashrc
source /etc/bashrc

# hostname
echo "10.1.0.4  t-elk >> /etc/host"
echo "10.1.0.5  t-filebeat >> /etc/host"

# auto start
echo "/root/mount-blob.sh" >> /etc/rc.local
echo "/root/run-logstash.sh &" >> /etc/rc.local
echo "iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601" >> /etc/rc.local
chmod +x /etc/rc.d/rc.local