#!/bin/bash

subscription=""
storageAccount=""
accountKey=""

az storage container list \
    --subscription $subscription \
    --account-name $storageAccount \
    --account-key $accountKey \
    --query "[*].[name]" \
    --output tsv > container-list.txt

cat container-list.txt | while read container
do

  blobSizeByte=`az storage blob list \
    --subscription $subscription \
    --include d \
    --account-name $storageAccount \
    --container-name $container \
    --account-key $accountKey \
    --query "[*].[properties.contentLength]" \
    --output tsv | paste --serial --delimiters=+ | bc`

  echo $container", "$((blobSizeByte/1024/1024/1024))"GB"
done