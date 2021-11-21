# necessary config & script
cd /root
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/mount-azblob.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/import-log.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/delete-index.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/update-config.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/config/fuse_connection.cfg
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/config/logstash.conf
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/config/filebeat.conf
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/config/azure-log-list.csv
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
source /etc/bashrc

# hostname
echo "10.1.0.4  t-elk >> /etc/host"
echo "10.1.0.5  t-filebeat >> /etc/host"

# auto start
echo "/root/mount-blob.sh" >> /etc/rc.local
echo "/root/run-logstash.sh &" >> /etc/rc.local
echo "iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601" >> /etc/rc.local
chmod +x /etc/rc.d/rc.local