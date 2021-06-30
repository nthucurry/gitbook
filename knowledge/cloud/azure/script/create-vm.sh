#!/bin/bash
###################################
# bigdata: a7bdf2e3-b855-4dda-ac93-047ff722cbbd
# auo    : de61f224-9a69-4ede-8273-5bcef854dc20
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="DBA_Test"
###################################
vm_name=$1
image="OpenLogic:CentOS:7_9:7.9.2021020400"
size="Standard_B2s" # CPU, RAM
os_disk_size="30" # GB
admin="azadmin"
password="AzureK8S2021"
location="southeastasia"
subnet="Infra"
vnet="BigDataVNet"
ssh_key_values="~/.ssh/id_rsa.pub"
###################################
az account set -s $subscription
echo "[Subscription.....] "`az account show --query name`
echo "[Resource Group...] "$resource_group
###################################

az vm create \
--name $vm_name \
--resource-group $resource_group \
#--admin-password $password \
--admin-username $admin \
--enable-agent true \
--image $image \
--location $location \
--size $size \
--os-disk-size-gb $os_disk_size \
--vnet-name "" \
--subnet "" \
--nsg "" \
--public-ip-address "" \
--nics $vm_name \
--license-type none \
--authentication-type ssh \
--ssh-key-values $ssh_key_values

###################################

ssh $admin@$vn_name sudo timedatectl set-timezone Asia/Taipei
ssh $admin@$vn_name wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/k8s/initial-k8s.sh
ssh $admin@$vn_name chmod +x initial-k8s.sh