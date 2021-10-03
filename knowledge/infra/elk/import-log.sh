#!/bin/bash

getYY=`date +%Y`
getMM="09" #`date +%m`
getDD="28" #`date +%d`
getHH="00" #`date +%H`

elasticsearch_url="t-elk"
index_pattern="azure-log"
input_log="/mnt/storagedbak8s/insights-metrics-pt1m/resourceId=/SUBSCRIPTIONS/DE61F224-9A69-4EDE-8273-5BCEF854DC20/RESOURCEGROUPS/DBA/PROVIDERS/MICROSOFT.WEB/SITES/DBAAPPTS/y=$getYY/m=$getMM/d=$getDD/h=$getHH/m=00/PT1H.json"

cat << EOF | tee /root/logstash.conf
input {
    file {
        start_position => "beginning"
        path => "$input_log"
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

/usr/share/logstash/bin/logstash -f /root/logstash.conf