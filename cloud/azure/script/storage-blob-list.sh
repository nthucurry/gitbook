az storage blob list \
    --subscription auobigdata \
    --account-name auobigdatagwadlslog \
    --container-name insights-activity-logs \
    --query "[*].[properties.contentLength]" \
    --output tsv | paste --serial --delimiters=+ | bc