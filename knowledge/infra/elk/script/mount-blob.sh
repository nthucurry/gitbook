# file upload
blobfuse /data/insights-logs-storagewrite \
    --tmp-path=/mnt/resource/blobfusetmp/storagewrite \
    --config-file=/root/fuse_file_upload.cfg

# firewall
blobfuse /data/insights-logs-azurefirewall \
    --tmp-path=/mnt/resource/blobfusetmp/azurefirewall \
    --config-file=/root/fuse_firewall.cfg

# application gateway
blobfuse /data/insights-logs-applicationgatewayaccesslog \
    --tmp-path=/mnt/resource/blobfusetmp/logs-applicationgatewayaccesslog \
    --config-file=/root/fuse_app_gw.cfg

# nsg
blobfuse /data/insights-logs-networksecuritygroupevent \
    --tmp-path=/mnt/resource/blobfusetmp/networksecuritygroupevent \
    --config-file=/root/fuse_nsg.cfg