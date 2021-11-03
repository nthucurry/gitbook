#!/bin/bash

getYY=`date +%Y`
getMM=`date +%m`
getDD=`date +%d`
getHH=`date +%H --date="-9 Hour"` # LST -> UTC

elasticsearch_url="t-elk"
index_pattern="azure-file-upload"
duration=60

#find /mnt/auobigdatagwadlslog/insights-logs-storagewrite -iname "*.json" | sort -i >> import-log-bulk.list

cat import-log-bulk.list | while read line
do

if [[ $line != *"y=$getYY/m=$getMM/d=$getDD/h=$getHH/m=00"* ]];then

log_path=$line
cat << EOF | tee /root/logstash.conf > /root/conf_$index_pattern.logstash
input {
  file {
    start_position => "beginning"
    path => "$log_path"
    sincedb_path => "/dev/null"
  }
}

filter {
  json {
    source => "message"
    target => "log"
  }
}

output {
  elasticsearch {
    hosts => "http://$elasticsearch_url:9200"
    index => "$index_pattern"
  }
  stdout {}
}
EOF

fi

sleep $duration

done