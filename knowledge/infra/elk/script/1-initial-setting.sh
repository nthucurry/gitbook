# necessary config & script
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/mount-azblob.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/import-log.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/script/delete-index.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/config/fuse_connection.cfg
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/elk/config/logstash.conf

# environment varible
echo "alias sre='systemctl restart elasticsearch.service'" >> /etc/bashrc
echo "alias srk='systemctl restart kibana.service'" >> /etc/bashrc
echo "alias srl='systemctl restart logstash.service'" >> /etc/bashrc
echo "alias sse='systemctl status elasticsearch.service'" >> /etc/bashrc
echo "alias ssk='systemctl status kibana.service'" >> /etc/bashrc
echo "alias ssl='systemctl status logstash.service'" >> /etc/bashrc
source /etc/bashrc

# hostname
echo "10.1.0.4  t-elk >> /etc/host"
echo "10.1.0.5  t-filebeat >> /etc/host"