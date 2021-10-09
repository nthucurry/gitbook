- [Reference](#reference)
- [安裝步驟](#安裝步驟)
    - [基本處置](#基本處置)
    - [Java](#java)
    - [Elasticsearch](#elasticsearch)
    - [Kibana](#kibana)
    - [Logstash](#logstash)
    - [轉 Port (5601 to 80, option)](#轉-port-5601-to-80-option)
- [匯入資料](#匯入資料)
- [Filebeat](#filebeat)

# Reference
- [How To Install ELK Stack on CentOS 7 / Fedora 31/30/29](https://computingforgeeks.com/how-to-install-elk-stack-on-centos-fedora/)
- [ELK學習筆記(2)：在ElasticSearch匯入及查詢 Sample Data](https://atceiling.blogspot.com/2018/05/linux3elasticsearch-sample-data.html)
- [Day 11 ELK 收集系統 Log](https://ithelp.ithome.com.tw/articles/10200989)
- [Elasticsearch issue with "cluster_uuid" : "_na_" and license in null](https://stackoverflow.com/questions/67451816/elasticsearch-issue-with-cluster-uuid-na-and-license-in-null)

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
- 環境變數設定
    ```bash
    echo "alias sre='systemctl restart elasticsearch.service'" >> /etc/bashrc
    echo "alias srk='systemctl restart kibana.service'" >> /etc/bashrc
    echo "alias srl='systemctl restart logstash.service'" >> /etc/bashrc
    echo "alias sse='systemctl status elasticsearch.service'" >> /etc/bashrc
    echo "alias ssk='systemctl status kibana.service'" >> /etc/bashrc
    echo "alias ssl='systemctl status logstash.service'" >> /etc/bashrc
    ```

## Java
- `yum install java-openjdk-devel java-openjdk -y`

## Elasticsearch
- `yum install elasticsearch -y`
- 更新資料存放位置
    - `mkdir -p /data/log`
    - `sed -i 's/path.data: \/var\/lib\/elasticsearch/path.data: \/data/g' /etc/elasticsearch/elasticsearch.yml`
    - `sed -i 's/path.logs: \/var\/log\/elasticsearch/path.logs: \/data\/log/g' /etc/elasticsearch/elasticsearch.yml`
- 設定 elasticsearch 記憶體使用上限及下限，重開 VM 記憶體才會生效
    - `sed -i 's/## -Xms4g/-Xms1g/g' /etc/elasticsearch/jvm.options`
    - `sed -i 's/## -Xmx4g/-Xmx1g/g' /etc/elasticsearch/jvm.options`
- `vi /etc/elasticsearch/elasticsearch.yml`
    ```yml
    node.name: node-1
    cluster.initial_master_nodes: ["node-1"]
    network.host: 0.0.0.0 # localhost 僅本地端可以連，0.0.0.0 代表任何位址都可存取
    http.port: 9200 # 綁定 Port，預設 9200
    discovery.seed_hosts: ["127.0.0.1", "[::1]"]
    ```
- 啟動服務
    - `systemctl start elasticsearch.service`
    - `systemctl enable elasticsearch.service`
    - 如果遇到啟動錯誤，參考 [ElasticSearch – 啟動失敗 – Service Start Operation Timed Out](https://terryl.in/zh/elasticsearch-service-start-operation-timed-out/)
        - `sed -i 's/TimeoutStartSec=75/TimeoutStartSec=500/g' /usr/lib/systemd/system/elasticsearch.service`
        - `systemctl daemon-reload`
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
    - 如果啟動錯誤: Kibana server is not ready yet
        - `curl -XDELETE "http://t-elk:9200/.kibana_1"`
- 版本
    - `/usr/share/kibana/bin/kibana --version --allow-root`

## Logstash
- `yum install logstash -y`
    - `systemctl start logstash.service`
    - `systemctl enable logstash.service`
- `vi /etc/logstash/logstash.yml`

## 轉 Port (5601 to 80, option)
- `sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601`
- 開機後生效
    - `echo "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601" >> /etc/rc.local`

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
    - 刪除 index
        - `curl -XDELETE "t-elk:9200/*"`
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
    ```yaml
    setup.kibana:
        #host: "t-elk:5601"
    output.elasticsearch:
        #hosts: ["t-elk:9200"]
    output.logstash:
        hosts: ["t-elk:5044"]
    ```
- 啟動服務
    - `systemctl start filebeat`
    - `systemctl enable filebeat`