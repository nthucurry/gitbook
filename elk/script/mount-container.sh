# nsg
blobfuse /data-from-cloud/my/insights-logs-networksecuritygroupflowevent \
    --tmp-path=/mnt/resource/blobfusetmp/networksecuritygroupevent \
    --config-file=/root/fuse_my-nsg.cfg
blobfuse /data-from-cloud/eda/insights-logs-networksecuritygroupflowevent \
    --tmp-path=/mnt/resource/blobfusetmp/networksecuritygroupevent \
    --config-file=/root/fuse_eda-nsg.cfg

# waf access
blobfuse /data-from-cloud/auo/insights-logs-applicationgatewayaccesslog \
    --tmp-path=/mnt/resource/blobfusetmp/applicationgatewayaccesslog \
    --config-file=/root/fuse_auo-waf-access.cfg

# aad audit
blobfuse /data-from-cloud/auo/am-auditlogs \
    --tmp-path=/mnt/resource/blobfusetmp/auditlogs \
    --config-file=/root/fuse_auo-auditlogs.cfg

# m365 office activity
blobfuse /data-from-cloud/auo/am-officeactivity \
    --tmp-path=/mnt/resource/blobfusetmp/officeactivity \
    --config-file=/root/fuse_auo-office-activity.cfg