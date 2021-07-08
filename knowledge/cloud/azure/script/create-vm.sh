#!/bin/bash
###################################
# subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
# resource_group="DBA-K8S"
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="DBA_Test"
vm_name=$1
image="OpenLogic:CentOS:7_9:7.9.2021020400"
size="Standard_B2s" # CPU, RAM
os_disk_size="30" # GB
admin="azadmin"
password="AzureK8S2021"
location="southeastasia"
subnet=""
vnet=""
ssh_key_values="~/.ssh/id_rsa.pub"
###################################
az account set -s $subscription
echo "[Create VM........] "$vm_name
echo "[Subscription.....] "`az account show --query name`
echo "[Resource Group...] "$resource_group
###################################
if [[ $resource_group == "DBA_Test" ]] || [[ $resource_group == "DBA-K8S" ]]; then
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
    --vnet-name "" \
    --subnet "" \
    --nsg "" \
    --public-ip-address "" \
    --nics $vm_name \
    --license-type none \
    --authentication-type all \
    --ssh-key-values $ssh_key_values
    if [[ uname == "Linux" ]]; then
        # In office environment
        ssh -oStrictHostKeyChecking=no $admin@$vm_name sudo timedatectl set-timezone Asia/Taipei
        ssh -oStrictHostKeyChecking=no $admin@$vm_name wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/k8s/initial-k8s.sh
        ssh -oStrictHostKeyChecking=no $admin@$vm_name chmod +x initial-k8s.sh
        ssh -oStrictHostKeyChecking=no $admin@$vm_name 'echo "10.248.15.6  k8m1" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$vm_name 'echo "10.248.15.7  k8m2" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$vm_name 'echo "10.248.15.10 k8m3" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$vm_name 'echo "10.248.15.11 k8n1" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$vm_name 'echo "10.248.15.12 k8n2" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$vm_name 'echo "10.248.15.13 k8n3" | sudo tee -a /etc/hosts'
    else
        # In home environment
        public_ip=`az vm list -g $resource_group -d --query "[?name == '$vm_name'].publicIps" -o tsv`
        ssh -oStrictHostKeyChecking=no $admin@$public_ip sudo timedatectl set-timezone Asia/Taipei
        ssh -oStrictHostKeyChecking=no $admin@$public_ip wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/k8s/initial-k8s.sh
        ssh -oStrictHostKeyChecking=no $admin@$public_ip chmod +x initial-k8s.sh
        ssh -oStrictHostKeyChecking=no $admin@$public_ip 'echo "10.0.8.7  t-m1" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$public_ip 'echo "10.0.8.8  t-m2" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$public_ip 'echo "10.0.8.9  t-m3" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$public_ip 'echo "10.0.8.10 t-n1" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$public_ip 'echo "10.0.8.11 t-n2" | sudo tee -a /etc/hosts'
        ssh -oStrictHostKeyChecking=no $admin@$public_ip 'echo "10.0.8.12 t-n3" | sudo tee -a /etc/hosts'
    fi
else
    echo "[Warning...] It is not test resource group!!"
fi
###################################