### 刪除 RG 內的所有相同 resource
# Microsoft.Web/sites
# Microsoft.Compute/virtualMachines
# Microsoft.Network/privateEndpoints
# Microsoft.Network/networkInterfaces
# Microsoft.Network/virtualNetworks
# Microsoft.Network/virtualNetworks/subnet
# Microsoft.Storage/storageAccounts
# Microsoft.Compute/disks
# Microsoft.Network/networkSecurityGroups
# Microsoft.Network/azureFirewalls

subscription="auobigdata"
resource_group="DBA_TEST"
resource_type="Microsoft.Network/virtualNetworks"
az resource list \
    --subscription $subscription \
    -g $resource_group \
    --query "[?type == '$resource_type'].name" | jq .[] -r > temp.txt
cat temp.txt | while read resource_name;
do
    az resource delete \
        --subscription $subscription \
        -g $resource_group \
        --resource-type $resource_type \
        -n $resource_name \
        --verbose
done

### 刪除單一 VM
# auobigdata
# Azure EA (AUO): de61f224-9a69-4ede-8273-5bcef854dc20

subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resource_group="DBA-K8S"
vm_name="auo-linux-oa-dnssrv"
nic="auo-linux-oa-dnssrv451"
disk_name="auo-linux-oa-dnssrv_OsDisk_1_ff7df6451d654443adddd1b51093bba1"
az account set -s $subscription
az vm delete -g $resource_group -n $vm_name --yes
az network nic delete -g $resource_group -n $nic
az disk delete -g $resource_group -n $disk_name --yes

### 查詢 VM
subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resource_group="EDA"
vm_name="maz-jiratest"
az account set -s $subscription
az vm show -g $resource_group -n $vm_name -d
# az vm list -g $resource_group -d

### 建 Subnet
echo "AKS,10.248.0.0/21" >> ~/temp.txt
echo "PrivateEndpoint,10.248.8.0/22" >> ~/temp.txt
echo "VM,10.248.12.0/23" >> ~/temp.txt

subscription="auobigdata"
resource_group="Global"
vnet_name="BigDataVNet"
cat temp.txt | while read line;
do
    subnet_name=`echo $line | awk 'BEGIN {FS=","} {print $1}'`
    address_prefixes=`echo $line | awk 'BEGIN {FS=","} {print $2}'`
    az network vnet subnet create \
        --address-prefixes $address_prefixes \
        -n $subnet_name \
        -g $resource_group \
        --vnet-name $vnet_name \
        --subscription $subscription
done
rm ~/temp.txt


cat temp.txt | while read line;
do
    subnet_name=`echo $line | awk 'BEGIN {FS=","} {print $1}'`
    address_prefixes=`echo $line | awk 'BEGIN {FS=","} {print $2}'`
    echo $subnet_name, $address_prefixes
done

subscription="auobigdata"
az feature register --name AllowNfsFileShares \
                    --namespace Microsoft.Storage \
                    --subscription $subscription
az provider register --namespace Microsoft.Storage

###
az vm list -g EDA -d

### NSG
# auobigdata
# Azure EA (AUO): de61f224-9a69-4ede-8273-5bcef854dc20

subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resource_group="Global"
az network nsg list -g $resource_group --subscription $subscription

subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resource_group="Global"
nsg_name="AUO_Azure_Default"
az network nsg show --subscription $subscription \
                    -g $resource_group \
                    -n $nsg_name \
                    --query "securityRules[]" \
                    -o table > ~/table.txt

### Application Gateway
$context = Get-AzSubscription -SubscriptionId a7bdf2e3-b855-4dda-ac93-047ff722cbbd
Set-AzContext $context

$vnet = Get-AzVirtualNetwork -Name VNetTEST -ResourceGroupName DBA_Test
Get-AzVirtualNetworkSubnetConfig -Name MyAGSubnet -VirtualNetwork $vnet