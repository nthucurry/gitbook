#!/bin/bash

getYY=`date +%Y`
getMM=`date +%m`
getDD=`date +%d`
getHH=`date +%H --date="-9 Hour"` # UTC - 1
elasticsearch_url="t-elk"

cat /root/azure-log-list.csv | while read line
do
if [[ $line != *"#"* ]]; then
  log_dir_path=`echo $line | awk -F"," '{print $1}'`
  index_pattern=`echo $line | awk -F"," '{print $2}'`
  duration=`echo $line | awk 'BEGIN {FS=","} {print $3}'`
  log_path="$log_dir_path/y=$getYY/m=$getMM/d=$getDD/h=$getHH/m=00/PT1H.json"
if [[ -f $log_path ]];then
cat << EOF | tee /root/logstash.conf > /root/logstash_$index_pattern.conf
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
  #stdout {}
}
EOF
  sleep $duration
fi
fi
done