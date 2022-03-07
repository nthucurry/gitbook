#!/bin/bash
###################################
# echo "  * Azure EA (1)"
# echo "  * Big Data (2)"
###################################
# echo "Choise 1 or 2: " $1
# read info

info=$1

if [[ $info == "1" ]]; then
    subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
else
    subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
fi

az group list --query "[].name" -o tsv | while read resourceGroup
do
  az vm list \
    --subscription $subscription \
    --show-details -g $resourceGroup \
    --query \
      "[].{ \
        resourceGroup: resourceGroup, \
        name: name, \
        privateIps: privateIps, \
        osType: storageProfile.osDisk.osType, \
        offer: storageProfile.imageReference.offer, \
        exactVersion: storageProfile.imageReference.exactVersion, \
        publisher: storageProfile.imageReference.publisher \
      }"
done