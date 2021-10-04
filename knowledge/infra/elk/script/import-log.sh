#!/bin/bash

getYY=`date +%Y`
getMM="09" #`date +%m`
getDD="28" #`date +%d`
getHH="00" #`date +%H --date="-8 Hour"` # UTC

elasticsearch_url="t-elk"
index_pattern="azure-log"
subscription="XXXXX"
log_path="/mnt/log/insights-logs-storagewrite/resourceId=/subscriptions/$subscription/resourceGroups/Global/providers/Microsoft.Storage/storageAccounts/auobigdatagwadls/blobServices/default/y=$getYY/m=$getMM/d=$getDD/h=$getHH/m=00/PT1H.json"

cat << EOF | tee /root/logstash.conf
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

/usr/share/logstash/bin/logstash -f /root/logstash.conf --path.data=/root/