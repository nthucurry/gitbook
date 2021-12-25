# azure nsg
blobfuse /data-from-cloud/my-insights-logs-networksecuritygroupflowevent \
    --tmp-path=/mnt/resource/blobfusetmp/insights-logs-networksecuritygroupflowevent \
    --config-file=/root/fuse_my-azure-nsg.cfg

# azure waf access
blobfuse /data-from-cloud/my-insights-logs-applicationgatewayaccesslog \
    --tmp-path=/mnt/resource/blobfusetmp/insights-logs-applicationgatewayaccesslog \
    --config-file=/root/fuse_my-azure-waf-access.cfg

# azure activity
blobfuse /data-from-cloud/my-insights-activity-logs \
    --tmp-path=/mnt/resource/blobfusetmp/insights-activity-logs \
    --config-file=/root/fuse_my-azure-activity.cfg

# aad audit
blobfuse /data-from-cloud/aad-am-auditlogs \
    --tmp-path=/mnt/resource/blobfusetmp/am-auditlogs \
    --config-file=/root/fuse_aad-audit.cfg

# m365 office activity
blobfuse /data-from-cloud/m365-am-officeactivity \
    --tmp-path=/mnt/resource/blobfusetmp/am-officeactivity \
    --config-file=/root/fuse_m365-office-activity.cfg