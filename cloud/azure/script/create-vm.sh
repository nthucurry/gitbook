#!/bin/bash
###################################
echo "  * Azure EA : WKC      (1)"
echo "  * Azure EA : DBA-K8S  (2)"
echo "  * Big Data : DBA_Test (3)"
###################################
echo "Choise 1, 2, 3: "
read info
if [[ $info == "1" ]]; then
    subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
    resource_group="WKC"
elif [[ "$info" = "2" ]]; then
    subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
    resource_group="DBA-K8S"
    nsg="t-nsg"
    nsg_home_rule="from_Home"
    public_home_ip=`curl -k https://ifconfig.me`
else
    subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
    resource_group="DBA_Test"
fi
###################################
echo "Input VM name: "
read vm_name
#image="OpenLogic:CentOS:7_9:7.9.2021020400"
#image="OpenLogic:CentOS:6.10:6.10.2020042900"
image="tidalmediainc:ubuntu-server-20-04-minimal:ubuntu-20-04-minimal:1.0.2"
size="Standard_B2s" # CPU, RAM
os_disk_size="30" # GB
admin="azadmin"
password="AzureNcu5540"
location="southeastasia"
subnet=""
vnet=""
ssh_key_values="~/.ssh/id_rsa.pub"
###################################
az account set -s $subscription
echo "[Subscription.....] "`az account show --query name`
echo "[Resource Group...] "$resource_group
echo "[Create VM........] "$vm_name
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
    if [[ `uname` == "Linux" ]]; then
        # In office environment
        ssh -oStrictHostKeyChecking=no $admin@$vm_name sudo timedatectl set-timezone Asia/Taipei
        ssh -oStrictHostKeyChecking=no $admin@$vm_name "echo alias vi=\'vim\' | sudo tee -a /etc/bashrc"
        ssh -oStrictHostKeyChecking=no $admin@$vm_name "echo alias grep=\'grep --color=always\' | sudo tee -a /etc/bashrc"
        ssh -oStrictHostKeyChecking=no $admin@$vm_name "echo alias tree=\'tree --charset ASCII\' | sudo tee -a /etc/bashrc"
    else
        # In home environment
        az vm auto-shutdown -g $resource_group -n $vm_name --time 1500
        az network nsg rule update \
            -g $resource_group \
            --nsg-name $nsg \
            -n $nsg_home_rule \
            --source-address-prefixes "$public_home_ip"
        # public_ip=`az vm list -g $resource_group -d --query "[?name == '$vm_name'].publicIps" -o tsv`
        ssh -oStrictHostKeyChecking=no $admin@$vm_name.southeastasia.cloudapp.azure.com sudo timedatectl set-timezone Asia/Taipei
        ssh -oStrictHostKeyChecking=no $admin@$vm_name.southeastasia.cloudapp.azure.com "echo alias vi=\'vim\' | sudo tee -a /etc/bashrc"
        ssh -oStrictHostKeyChecking=no $admin@$vm_name.southeastasia.cloudapp.azure.com "echo alias grep=\'grep --color=always\' | sudo tee -a /etc/bashrc"
        ssh -oStrictHostKeyChecking=no $admin@$vm_name.southeastasia.cloudapp.azure.com "echo alias tree=\'tree --charset ASCII\' | sudo tee -a /etc/bashrc"
        ssh -oStrictHostKeyChecking=no $admin@$vm_name.southeastasia.cloudapp.azure.com wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/k8s/script/initial-k8s.sh
        ssh -oStrictHostKeyChecking=no $admin@$vm_name.southeastasia.cloudapp.azure.com chmod +x initial-k8s.sh
    fi
else
    echo "[Warning...] It is not test resource group!!"
fi
###################################
