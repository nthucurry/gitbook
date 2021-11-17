- [安裝步驟](#安裝步驟)
  - [基本處置](#基本處置)
  - [Logstash](#logstash)
- [Filebeat](#filebeat)

# 安裝步驟
## 基本處置
- `yum update -y`
- `timedatectl set-timezone Asia/Taipei`

## Logstash
- `docker pull docker.elastic.co/logstash/logstash:7.15.2`
- `sudo mkdir -p /usr/share/logstash/pipeline/`
- `docker run --rm -it -v ~/pipeline/:/usr/share/logstash/pipeline/ docker.elastic.co/logstash/logstash:7.15.2`
- `docker run -d -v /var/log/messages:/logs -v ~:/data --link es:es peihsinsu/logstash /logstash-1.4.2/bin/logstash -f /home/azadmin/filebeat.conf`


docker run -d -it --restart=always  \
--privileged=true  \
--name=logstash -p 5044:5044 -p 9600:9600  \
-v /usr/local/logstash/pipeline/:/usr/share/logstash/pipeline/  \
-v /usr/local/logstash/config/:/usr/share/logstash/config/ docker.elastic.co/logstash/logstash:6.4.3

# Filebeat
- `docker pull docker.elastic.co/beats/filebeat:7.15.2`
- `docker run docker.elastic.co/beats/filebeat:7.15.2`