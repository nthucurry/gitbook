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

### 建 Subnet

echo "AKS,10.248.0.0/21" >> ~/temp.txt
echo "PrivateEndpoint,10.248.8.0/22" >> ~/temp.txt
echo "VM,10.248.12.0/23" >> ~/temp.txt
echo "C4A-Databricks-Private,10.248.14.0"/25 >> ~/temp.txt
echo "C4A-Databricks-Public,10.248.14.128"/25 >> ~/temp.txt
echo "C5D-Databricks-Private,10.248.15.0"/25 >> ~/temp.txt
echo "C5D-Databricks-Public,10.248.15.128"/25 >> ~/temp.txt
echo "C5E-Databricks-Private,10.248.16.0"/25 >> ~/temp.txt
echo "C5E-Databricks-Public,10.248.16.128"/25 >> ~/temp.txt
echo "C6B-Databricks-Private,10.248.17.0"/25 >> ~/temp.txt
echo "C6B-Databricks-Public,10.248.17.128"/25 >> ~/temp.txt
echo "C6C-Databricks-Private,10.248.18.0"/25 >> ~/temp.txt
echo "C6C-Databricks-Public,10.248.18.128"/25 >> ~/temp.txt
echo "FE-Databricks-Private,10.248.19.0"/25 >> ~/temp.txt
echo "FE-Databricks-Public,10.248.19.128"/25 >> ~/temp.txt
echo "ITDEV-Databricks-Private,10.248.20.0"/25 >> ~/temp.txt
echo "ITDEV-Databricks-Public,10.248.20.128"/25 >> ~/temp.txt
echo "ITPOC-Databricks-Private,10.248.21.0"/25 >> ~/temp.txt
echo "ITPOC-Databricks-Public,10.248.21.128"/25 >> ~/temp.txt
echo "L3C-Databricks-Private,10.248.22.0"/25 >> ~/temp.txt
echo "L3C-Databricks-Public,10.248.22.128"/25 >> ~/temp.txt
echo "L3D-Databricks-Private,10.248.23.0"/25 >> ~/temp.txt
echo "L3D-Databricks-Public,10.248.23.128"/25 >> ~/temp.txt
echo "L4A-Databricks-Private,10.248.24.0"/25 >> ~/temp.txt
echo "L4A-Databricks-Public,10.248.24.128"/25 >> ~/temp.txt
echo "L4B-Databricks-Private,10.248.25.0"/25 >> ~/temp.txt
echo "L4B-Databricks-Public,10.248.25.128"/25 >> ~/temp.txt
echo "L5AB-Databricks-Private,10.248.26.0"/25 >> ~/temp.txt
echo "L5AB-Databricks-Public,10.248.26.128"/25 >> ~/temp.txt
echo "L5C-Databricks-Private,10.248.27.0"/25 >> ~/temp.txt
echo "L5C-Databricks-Public,10.248.27.128"/25 >> ~/temp.txt
echo "L5D-Databricks-Private,10.248.28.0"/25 >> ~/temp.txt
echo "L5D-Databricks-Public,10.248.28.128"/25 >> ~/temp.txt
echo "L6A-Databricks-Private,10.248.29.0"/25 >> ~/temp.txt
echo "L6A-Databricks-Public,10.248.29.128"/25 >> ~/temp.txt
echo "L6B-Databricks-Private,10.248.30.0"/25 >> ~/temp.txt
echo "L6B-Databricks-Public,10.248.30.128"/25 >> ~/temp.txt
echo "L6K-Databricks-Private,10.248.31.0"/25 >> ~/temp.txt
echo "L6K-Databricks-Public,10.248.31.128"/25 >> ~/temp.txt
echo "L7A-Databricks-Private,10.248.32.0"/25 >> ~/temp.txt
echo "L7A-Databricks-Public,10.248.32.128"/25 >> ~/temp.txt
echo "L7B-Databricks-Private,10.248.33.0"/25 >> ~/temp.txt
echo "L7B-Databricks-Public,10.248.33.128"/25 >> ~/temp.txt
echo "L8A-Databricks-Private,10.248.34.0"/25 >> ~/temp.txt
echo "L8A-Databricks-Public,10.248.34.128"/25 >> ~/temp.txt
echo "L8B-Databricks-Private,10.248.35.0"/25 >> ~/temp.txt
echo "L8B-Databricks-Public,10.248.35.128"/25 >> ~/temp.txt
echo "MMFA-Databricks-Private,10.248.36.0"/25 >> ~/temp.txt
echo "MMFA-Databricks-Public,10.248.36.128"/25 >> ~/temp.txt
echo "QA-Databricks-Private,10.248.37.0"/25 >> ~/temp.txt
echo "QA-Databricks-Public,10.248.37.128"/25 >> ~/temp.txt

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

reg add "HKLM\SYSTEM\CurrentControlSet\Services\TermService\Parameters" /v SpecifiedLicenseServers /t REG_MULTI_SZ /d "10.250.12.172"