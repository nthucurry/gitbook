#!/bin/bash

subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
az account set -s $subscription

az appservice plan list --query "[].{name:name,resource_group:resourceGroup}" -o tsv | sort > asp_list.txt
sed -i "s/\t/,/g" asp_list.txt

cat asp_list.txt | while read line
do
#    echo $line
    asp_name=`echo $line | awk -F"," '{print $1}'`
    resource_group=`echo $line | awk -F"," '{print $2}'`
    vnet_integration=`az appservice vnet-integration list \
    --plan $asp_name \
    --resource-group $resource_group \
    --query "[].{vnet_integration:vnetResourceId}" -o tsv | awk -F"/" '{print $(NF)}'`

    echo $asp_name,$resource_group,$vnet_integration
done

[ -e asp_list.txt ] && rm asp_list.txt