az network firewall create \
    --name "fortiweb" \
    --subscription "de61f224-9a69-4ede-8273-5bcef854dc20" \
    --resource-group "DBA-K8S" \
    --allow-active-ftp false \
    --firewall-policy "fortiweb" \
    --location "southeastasia" \
    --sku AZFW_VNet \
    --tier "Standard"

# az network firewall ip-config create \
#     --subscription "de61f224-9a69-4ede-8273-5bcef854dc20" \
#     --resource-group "DBA-K8S" \
#     --firewall-name "fortiweb" \
#     --name fortiweb-fw \
#     --public-ip-address "/subscriptions/de61f224-9a69-4ede-8273-5bcef854dc20/resourceGroups/DBA-K8S/providers/Microsoft.Network/publicIPAddresses/fortiweb-fw" \
#     --vnet-name "t-vnet"