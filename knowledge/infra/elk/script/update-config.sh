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
log_path="$log_dir_path/y=$getYY/m=$getMM/d=$getDD/h=$getHH/m=00/PT1H.json"

cat << EOF | tee /root/logstash.conf > /dev/null
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

sleep 30

fi

done