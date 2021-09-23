- [Reference](#reference)
- [名詞解釋](#名詞解釋)
- [安裝步驟](#安裝步驟)
    - [更新 Package](#更新-package)
    - [Java](#java)
    - [Elasticsearch](#elasticsearch)
    - [Kibana](#kibana)
    - [Logstash](#logstash)
    - [轉 Port (5601 to 80)](#轉-port-5601-to-80)
- [匯入資料](#匯入資料)

# Reference
- [How To Install ELK Stack on CentOS 7 / Fedora 31/30/29](https://computingforgeeks.com/how-to-install-elk-stack-on-centos-fedora/)
- [ELK學習筆記(2)：在ElasticSearch匯入及查詢 Sample Data](https://atceiling.blogspot.com/2018/05/linux3elasticsearch-sample-data.html)

# 名詞解釋
- Elasticsearch: This is an open source, distributed, RESTful, JSON-based search engine. It is scalable, easy to use, and flexible
- Logstash: This is a server‑side data processing pipeline that ingests data from multiple sources simultaneously, transforms it, and then sends it to a “stash” like Elasticsearch.
- Kibana: UI

# 安裝步驟
## 更新 Package
## Java
- `yum install java-openjdk-devel java-openjdk -y`
- `vi /etc/elasticsearch/jvm.options`
    ```
    -Xms1g
    -Xmx1g
    ```

## Elasticsearch
- update repo
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
- `yum install elasticsearch -y`
- 啟動服務
    - `systemctl start elasticsearch.service`
    - `systemctl enable elasticsearch.service`
- 測試
    - curl http://127.0.0.1:9200

## Kibana
- `yum install kibana -y`
- `vi /etc/kibana/kibana.yml`
- `systemctl start kibana.service`
- `systemctl enable kibana.service`

## Logstash
- `yum install logstash -y`

## 轉 Port (5601 to 80)
- `iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5601`

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
            hosts => "http://localhost:9200"
            index => "demo-json"
        }
        stdout {}
    }
    ```
- `/usr/share/logstash/bin/logstash -f json-read.conf`
- `curl localhost:9200/demo-json/_search?pretty=true`