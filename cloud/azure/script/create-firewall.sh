subscription="de61f224-9a69-4ede-8273-5bcef854dc20"
resourceGroup="DBA-K8S"
location="southeastasia"
firewall="fortiweb-fw"
policy="fortiweb-fw"
IPConfig="fortiweb-fw"
publicIP="fortiweb-fw"
vnet="t-vnet"

az configure --defaults group=$resourceGroup

# az network firewall create \
#     --name $firewall \
#     --resource-group $resourceGroup \
#     --location $location

# az network public-ip create \
#     --name $publicIP \
#     --resource-group $resourceGroup \
#     --location $location \
#     --allocation-method static \
#     --sku standard

az network firewall ip-config create \
    --firewall-name $firewall \
    --name $publicIP \
    --public-ip-address $publicIP \
    --vnet-name $vnet

# az network firewall update \
#     --name $firewall \
#     --resource-group $resourceGroup \
#     --firewall-policy $policy