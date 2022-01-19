vnet="BigDataVNet"
subnet="XXX"
ip_address="10.248.104.144/28"
resource_group="XXX"
app_1="App1"
app_2="App2"
nsg="BigDataNSG"
route="BigDataRoute"
service_endpoints="Microsoft.Storage"

echo "Step 1: " $resource_group
az webapp vnet-integration remove --resource-group $resource_group --name $app_1
az webapp vnet-integration remove --resource-group $resource_group --name $app_2

echo "Step 2: delete subnet"

echo "Step 3"
az network vnet subnet create \
    -g Global \
    -n $subnet \
    --nsg $nsg \
    --vnet-name $vnet \
    --address-prefixes $ip_address \
    --route-table $route \
    --service-endpoints $service_endpoints

az webapp vnet-integration add \
    --vnet $vnet \
    --subnet $subnet \
    --resource-group $resource_group \
    --name $app_1

az webapp vnet-integration add \
    --vnet $vnet \
    --subnet $subnet \
    --resource-group $resource_group \
    --name $app_2