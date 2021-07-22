#!/bin/bash

subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="Global"
vnet="BigDataVNet"
id="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.Network/"

az network vnet subnet list \
--resource-group $resource_group \
--vnet-name $vnet \
--query "[].name" -o tsv | tee -a subnet-list.txt

cat subnet-list.txt | while read subnet
do
#    echo "az network vnet subnet show -g $resource_group -n $subnet --vnet-name $vnet"
    az network vnet subnet show \
    -g Global \
    -n $subnet \
    --vnet-name $vnet \
    --query "{vm: name, rg: resourceGroup, nsg: networkSecurityGroup.id, route: routeTable.id}" -o tsv | \
    sed "s|$id||g" >> subnet-detail.tsv

done

rm subnet-list.txt