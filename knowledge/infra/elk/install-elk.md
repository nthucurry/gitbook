- [Reference](#reference)
- [名詞解釋](#名詞解釋)
- [安裝步驟](#安裝步驟)
  - [基本處置](#基本處置)
  - [Java](#java)
  - [Elasticsearch](#elasticsearch)
  - [Kibana](#kibana)
  - [Logstash](#logstash)
  - [轉 Port (5601 to 80, option)](#轉-port-5601-to-80-option)
- [匯入資料](#匯入資料)
- [Filebeat](#filebeat)
- [排程](#排程)

# Reference
- [How To Install ELK Stack on CentOS 7 / Fedora 31/30/29](https://computingforgeeks.com/how-to-install-elk-stack-on-centos-fedora/)
- [ELK學習筆記(2)：在ElasticSearch匯入及查詢 Sample Data](https://atceiling.blogspot.com/2018/05/linux3elasticsearch-sample-data.html)
- [Day 11 ELK 收集系統 Log](https://ithelp.ithome.com.tw/articles/10200989)

# 名詞解釋
- Elasticsearch: This is an open source, distributed, RESTful, JSON-based search engine. It is scalable, easy to use, and flexible
- Logstash: This is a server‑side data processing pipeline that ingests data from multiple sources simultaneously, transforms it, and then sends it to a “stash” like Elasticsearch.
- Kibana: UI

# 安裝步驟
## 基本處置
- `yum update -y`
- `timedatectl set-timezone Asia/Taipei`
- add repo
    ```bash
    cat << EOF | tee /etc/yum.repos.d/elasticsearch.repo
    [elasticsearch-7.x]
    name=Elasticsearch repository for 7.x packages
    baseurl=https://artifacts.elastic.co/packages/7.x/yum
    gpgcheck=1
    gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
    enabled=1
    autorefresh=1
    type=rpm-md
    EOF

    # by proxy
    rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch --httpproxy 10.248.15.8 --httpport 80
    ```
- `yum clean all`
- `yum makecache`

## Java
- `yum install java-openjdk-devel java-openjdk -y`

## Elasticsearch
- `yum install elasticsearch -y`
- `vi /etc/elasticsearch/elasticsearch.yml`
    ```yml
    path.data: /var/lib/elasticsearch
    path.logs: /var/log/elasticsearch
    network.host: localhost # 僅本地端可以連，0.0.0.0 代表任何位址都可存取
    #network.host: 0.0.0.0
    network.bind_host: 0.0.0.0  # 綁定 IP
    http.port: 9200 # 綁定 Port，預設 9200
    discovery.seed_hosts: ["127.0.0.1", "[::1]"]
    ```
- 設定 elasticsearch 記憶體使用上限及下限
    - `vi /etc/elasticsearch/jvm.options`
        ```
        -Xms1g
        -Xmx1g
        ```
    - 重開 VM 記憶體才會生效
- 啟動服務
    - `systemctl start elasticsearch.service`
    - `systemctl enable elasticsearch.service`
    - 如果遇到啟動錯誤，參考 [ElasticSearch – 啟動失敗 – Service Start Operation Timed Out](https://terryl.in/zh/elasticsearch-service-start-operation-timed-out/)
        - `vi /usr/lib/systemd/system/elasticsearch.service`
        - `systemctl daemand-reload`
        - `systemctl show elasticsearch | grep ^Timeout`
- 測試
    - `curl http://t-elk:9200`

## Kibana
- `yum install kibana -y`
- `vi /etc/kibana/kibana.yml`
    ```yml
    server.port: 5601 # 設定 80, 443 都會無法啟動，無解
    server.host: "0.0.0.0"
    i18n.locale: "en"
    ```
- 啟動服務
    - `systemctl start kibana.service`
    - `systemctl enable kibana.service`
- 檢查服務狀態
    - `netstat -ntl | grep 5601`

## Logstash
- `yum install logstash -y`
    - `systemctl start logstash.service`
    - `systemctl enable logstash.service`
- `vi /etc/logstash/logstash.yml`

## 轉 Port (5601 to 80, option)
- `sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601`

# 匯入資料
- `vi /etc/logstash/conf.d/json-read.conf`
    ```conf
    input {
        file {
            start_position => "beginning"
            path => "/home/azadmin/PT1H.json"
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
            hosts => "http://t-elk:9200"
            index => "demo-json"
        }
        stdout {}
    }
    ```
- `/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/json-read.conf`
- `curl localhost:9200/demo-json/_search?pretty=true`
- 到 kibana 顯示 log 結果
    1. Index patterns > Create index pattern
    2. Discover

# Filebeat
- `rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch`
- add repo
    ```bash
    cat << EOF | tee /etc/yum.repos.d/elasticsearch.repo
    [elasticsearch-7.x]
    name=Elasticsearch repository for 7.x packages
    baseurl=https://artifacts.elastic.co/packages/7.x/yum
    gpgcheck=1
    gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
    enabled=1
    autorefresh=1
    type=rpm-md
    EOF
    ```
- `yum install filebeat -y`
- `vi /etc/filebeat/filebeat.yml`
- 啟動服務
    - `systemctl start filebeat`
    - `systemctl enable filebeat`

# 排程
```bash
Year=`date +%Y`
Month=`date +%m`
Day=`date +%d`
Hour=`date +%a --date="-2 Hour"`
Subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"

log_path="/mnt/log/insights-logs-storagewrite/resourceId=/subscriptions/$Subscription/resourceGroups/Global/providers/Microsoft.Storage/storageAccounts/auobigdatagwadls/blobServices/default/y=$Year/m=$Month/d=$Day/h=$Hour/m=00/PT1H.json"

echo $log_path

cat << EOF | tee /etc/logstash/conf.d/insights-metrics-pt1m.conf
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
        hosts => "http://localhost:9200"
        index => "file-write"
    }
    stdout {}
}
EOF

/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/file-write.conf
```