#/bin/bash
###################################
# bigdata: a7bdf2e3-b855-4dda-ac93-047ff722cbbd
# auo    : de61f224-9a69-4ede-8273-5bcef854dc20
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="DBA_Test"
###################################
vm_name="t-m1"
image="centos"
size="Standard_B2s" # CPU, RAM
os_disk_size="30" # GB
admin="azadmin"
password="AzurePOC2021"
location="southeastasia"
subnet="vm"
vnet="vnet-test"
###################################
az account set -s $subscription
echo "[Subscription...] "`az account show --query name`
###################################

az vm create \
--name $vm_name \
--resource-group $resource_group \
--admin-password $password \
--admin-username $admin \
--enable-agent true \
--image $image \
--location $location \
--size $size \
--os-disk-size-gb $os_disk_size \
--vnet-name $vnet \
--subnet $subnet \
--nsg "" \
--license-type none \
--authentication-type password