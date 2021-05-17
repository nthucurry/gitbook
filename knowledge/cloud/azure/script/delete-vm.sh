#/bin/bash
###################################
# bigdata: a7bdf2e3-b855-4dda-ac93-047ff722cbbd
# auo:     de61f224-9a69-4ede-8273-5bcef854dc20
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="DBA_Test"
vm_name=$1
###################################
az account set -s $subscription
echo "[Subscription...] "`az account show --query name`
###################################

if [[ $resource_group == "DBA_Test" ]] || [[ $resource_group == "DBA-K8S" ]]; then

    echo "[Resource Group...] "$resource_group
    disk_name=`az vm list -g $resource_group -d --query "[?name == '$vm_name'].storageProfile.osDisk.name" -o tsv`
    nic=`az vm list -g $resource_group -d --query "[?name == '$vm_name'].networkProfile.networkInterfaces"`

    az vm delete -g $resource_group -n $vm_name --yes
    az disk delete -g $resource_group -n $disk_name --yes
    # az network nic delete -g $resource_group -n $nic

else
    echo "[Warning...] It is not test resource group!!"
fi

cat /dev/null > ~/.ssh/known_hosts