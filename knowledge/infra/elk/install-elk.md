- [Reference](#reference)
- [安裝步驟](#安裝步驟)
    - [基本處置](#基本處置)
    - [Java](#java)
    - [Elasticsearch](#elasticsearch)
    - [Kibana](#kibana)
    - [Logstash](#logstash)
- [Filebeat](#filebeat)
- [匯入資料](#匯入資料)

# Reference
- [How To Install ELK Stack on CentOS 7 / Fedora 31/30/29](https://computingforgeeks.com/how-to-install-elk-stack-on-centos-fedora/)
- [ELK學習筆記(2)：在ElasticSearch匯入及查詢 Sample Data](https://atceiling.blogspot.com/2018/05/linux3elasticsearch-sample-data.html)
- [Day 11 ELK 收集系統 Log](https://ithelp.ithome.com.tw/articles/10200989)
- [Elasticsearch issue with "cluster_uuid" : "_na_" and license in null](https://stackoverflow.com/questions/67451816/elasticsearch-issue-with-cluster-uuid-na-and-license-in-null)
- [How to monitor your Azure infrastructure with Filebeat and Elastic Observability](https://cloudblogs.microsoft.com/opensource/2021/01/07/how-to-monitor-azure-infrastructure-filebeat-elastic-observability/)
- [How to manage Elasticsearch data across multiple indices with Filebeat, ILM, and data streams](https://www.elastic.co/blog/how-to-manage-elasticsearch-data-multiple-indices-filebeat-ilm-data-streams)
- [Logstash 最佳实践](https://doc.yonyoucloud.com/doc/logstash-best-practice-cn/index.html)

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
- `ln -s /etc/elasticsearch/elasticsearch.yml`
- `vi /etc/elasticsearch/elasticsearch.yml`
    ```yml
    node.name: node-1
    cluster.initial_master_nodes: ["node-1"]
    network.host: 0.0.0.0 # localhost 僅本地端可以連，0.0.0.0 代表任何位址都可存取
    http.port: 9200 # 綁定 Port，預設 9200
    discovery.seed_hosts: ["127.0.0.1", "[::1]"]
    xpack.security.enabled: false
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
- `ln -s /etc/kibana/kibana.yml`
- `vi /etc/kibana/kibana.yml`
    ```yml
    server.port: 5601 # 設定 80, 443 都會無法啟動，無解
    server.host: "0.0.0.0"
    i18n.locale: "en"
    ```
- 啟動服務
    - `systemctl start kibana.service`
    - `systemctl enable kibana.service`
- 轉 Port (5601 to 80, option)
    - `iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601`
- 版本
    - `/usr/share/kibana/bin/kibana --version --allow-root`

## Logstash
- `yum install logstash -y`
- 啟動服務
    - `systemctl start logstash.service`
    - `systemctl enable logstash.service`
- `ln -s /etc/logstash/logstash.yml ~`
- 修改 logstash 參數時，自動生效
    - `vi /etc/systemd/system/logstash.service`
    - `ExecStart=/usr/share/logstash/bin/logstash "-r" "–path.settings" "/etc/logstash"`
- `ln -s /etc/logstash/conf.d/logstash.conf ~`
- outupt log
    - `ln -s /var/log/logstash/logstash-plain.log`

# Filebeat
- `rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch`
- `yum install filebeat -y`
- `ln -s /etc/filebeat/filebeat.yml`
    - 需先設定 filebeat log 位置
- `ln -s /var/log/filebeat/filebeat`
- `vi /etc/filebeat/filebeat.yml`
    - [filebeat.yml](./config/filebeat.yml)
- 啟動服務 (要有耐心慢慢等)
    - `systemctl start filebeat`
    - `systemctl enable filebeat`
- 啟動模組
    - `filebeat modules enable azure`
    - `vi /etc/filebeat/modules.d/azure.yml`
    - `filebeat setup`

# 匯入資料
- `vi /etc/logstash/conf.d/logstash.conf`
    - [logstash.conf](./config/logstash.conf)
- 檢查 conf 格式
    - `logstash -f logstash.conf --config.test_and_exit true`
- `/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/json-read.conf`
    - 刪除 index
        - `curl -XDELETE "t-elk:9200/*"`
- `curl localhost:9200/demo-json/_search?pretty=true`
- 到 kibana 顯示 log 結果
    1. Index patterns > Create index pattern
    2. Discover
- 開機後，手動啟動 (自動啟動仍無法)
    - 啟動 logstash
        - `./import-log.sh &`
    - 更新 config
        - `./update-config.sh`