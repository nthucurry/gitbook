# /usr/share/logstash/bin/logstash -f /root/logstash.conf --config.reload.automatic | tee /root/_`date +%Y-%m%d-%H%M`
/usr/share/logstash/bin/logstash -f /root/filebeat.conf -r | tee /root/_logstash.log