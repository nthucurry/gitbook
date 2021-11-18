# /usr/share/logstash/bin/logstash -f /root/logstash.conf --config.reload.automatic
/usr/share/logstash/bin/logstash -f /root/filebeat.conf -r | tee /tmp/_`date +%Y-%m%d-%H%M`