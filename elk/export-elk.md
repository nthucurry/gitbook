# Reference
- [NodSource on GitHub](https://github.com/nodesource/distributions/blob/master/README.md)

# Elasticdump Installing
- 不要用 yum install elasticdump，版本會過舊
- `curl -fsSL https://rpm.nodesource.com/setup_current.x | bash -`
- `yum install gcc-c++ make -y`
- `yum install nodejs -y`
- `node --version`
    - v17.3.0
- `npm -v`
    - 8.3.0
- `npm install elasticdump -g`

# Export ElasticSearch Data
```bash
elasticdump \
  --input=http://t-elk:9200/$1 \
  --output=$1.json \
  --type=data \
  --sourceOnly=true
```