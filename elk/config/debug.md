# Free up disk space
This happens when Elasticsearch thinks the disk is running low on space so it puts itself into read-only mode.
```bash
curl -XPUT \
    -H "Content-Type: application/json" http://t-elk:9200/_all/_settings \
    -d '{"index.blocks.read_only_allow_delete": null}'
```

# no_shard_available_action_exception (Reason: index XXX-2022.05.20 has no active shard copy)
```bash
curl -XPUT \
    -H "Content-Type: application/json" http://t-elk:9200/_all/_settings \
    -d '{ "number_of_replicas": 0 }'
```