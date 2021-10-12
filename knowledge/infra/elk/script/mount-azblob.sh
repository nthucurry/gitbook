# file upload
blobfuse /mnt/auobigdatagwadlslog/insights-logs-storagewrite \
    --tmp-path=/mnt/resource/blobfusetmp \
    --config-file=/root/fuse_file_upload.cfg

# firewall
blobfuse /mnt/bigdatastoragefirewall/insights-logs-azurefirewall \
    --tmp-path=/mnt/resource/blobfusetmp \
    --config-file=/root/fuse_firewall.cfg

# application gateway
blobfuse /mnt/auogwadlslog/insights-logs-applicationgatewayaccesslog \
    --tmp-path=/mnt/resource/blobfusetmp \
    --config-file=/root/fuse_app_gw.cfg

# nsg
blobfuse /mnt/auogwadlslog/insights-logs-networksecuritygroupevent \
    --tmp-path=/mnt/resource/blobfusetmp \
    --config-file=/root/fuse_nsg.cfg