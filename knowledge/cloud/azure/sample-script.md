- [刪除 Resource Group 內的資源 (勿亂用)](#刪除-resource-group-內的資源-勿亂用)
- [刪除單一 VM](#刪除單一-vm)
- [開機 VM](#開機-vm)
- [查詢 VM](#查詢-vm)
- [建 Subnet](#建-subnet)
- [NSG](#nsg)
- [Application Gateway](#application-gateway)
- [Policy](#policy)
    - [Definition](#definition)
    - [Assignment](#assignment)
    - [State](#state)
- [檢查資源合規性 (undone)](#檢查資源合規性-undone)

# 刪除 Resource Group 內的資源 (勿亂用)
```bash
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
```

# 刪除單一 VM
```bash
# auobigdata
# Azure EA (AUO): de61f224-9a69-4ede-8273-5bcef854dc20

subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resource_group="DBA-K8S"
vm_name="vm-k8s-m2"
nic="vm-k8s-m2588"
disk_name="vm-k8s-m2_OsDisk_1_ad4bedb368b647aba5ef2bfeacf4a7a1"
az account set -s $subscription
az vm delete -g $resource_group -n $vm_name --yes
az network nic delete -g $resource_group -n $nic
az disk delete -g $resource_group -n $disk_name --yes
```

# 開機 VM
```bash
subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
myResourceGroupVM="DBA-K8S"
az account set -s $subscription
az vm start --resource-group $myResourceGroupVM --name t-k8s-m1
az vm start --resource-group $myResourceGroupVM --name t-k8s-m2
az vm start --resource-group $myResourceGroupVM --name t-k8s-n1
az vm start --resource-group $myResourceGroupVM --name t-k8s-n2
```

# 查詢 VM
```bash
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
resource_group="ITDEV_RG"
vm_name="maz-tbltest01"
az account set -s $subscription
az vm show -g $resource_group -n $vm_name -d
# az vm list -g $resource_group -d
az vm list -g DBA-K8S -d --query "[?name == 't-k8s-lb'].storageProfile.osDisk.name"
```

# 建 Subnet
```bash
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
```

# NSG
```bash
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
```

# Application Gateway
```powershell
$context = Get-AzSubscription -SubscriptionId a7bdf2e3-b855-4dda-ac93-047ff722cbbd
Set-AzContext $context

$vnet = Get-AzVirtualNetwork -Name VNetTEST -ResourceGroupName DBA_Test
Get-AzVirtualNetworkSubnetConfig -Name MyAGSubnet -VirtualNetwork $vnet
```

# Policy
## Definition
```bash
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
az policy definition list \
--subscription $subscription \
--query "[].{name:displayName, scope:parameters.effect.allowedValues}"
#-o tsv | grep -v "Deprecated" | sort
```
```bash
policy_definition_id="/providers/Microsoft.Authorization/policyDefinitions/687aa49d-0982-40f8-bf6b-66d1da97a04b"
az policy assignment list \
--query "[?policyDefinitionId == '$policy_definition_id'].{policy_name:displayName, status:parameters.effect.value}" \
-o tsv
```

## Assignment
```bash
policy_assignment_id="b6fa3ab31d0344e4942bfb8e"
az policy assignment show \
--name $policy_assignment_id \
--query "{ \
display_name:displayName, \
not_scopes:notScopes, \
parameter_effect_value:parameters.effect.value, \
policy_definition_id:policyDefinitionId, \
scope:scope \
}"
```
```json
{
  "display_name": "[必] [EDA] [限內網用] 禁止建立 VNet",
  "not_scopes": [
    "/subscriptions/a7bdf2e3-b855-4dda-ac93-047ff722cbbd/resourceGroups/Global",
    "/subscriptions/a7bdf2e3-b855-4dda-ac93-047ff722cbbd/resourceGroups/DBA_Test"
  ],
  "parameter": "Deny",
  "policy_definition_id": "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749",
  "scope": "/subscriptions/a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
}
```

## State
```bash
subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"
az policy state list \
--subscription $subscription \
--query "[].{policy_name:policyDefinitionName, action:policyDefinitionAction}" \
-o tsv
```

# 檢查資源合規性 (undone)
```bash
resource_group="auobigdata/openpose_rg"
policy_definition_id="/providers/Microsoft.Authorization/policyDefinitions/687aa49d-0982-40f8-bf6b-66d1da97a04b"
az policy assignment non-compliance-message list \
-g $resource_group -n $policy_definition_id
# https://jmespath.org/
```