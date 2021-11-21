# SSH session to a Linux container in Azure App Service
```bash
resource_group="DBA_Test"
app_name="ui-web-test"
az webapp create-remote-connection --resource-group $resource_group -n cfa-ui-web-official-test
```

# Installing TcpPing on Azure App Service Linux
```bash
apt-get install traceroute
apt-get install telnet
wget http://www.vdberg.org/~richard/tcpping
chmod 755 tcpping
apt install bc
```

# Azure DNS private zones
- `WEBSITE_DNS_SERVER` with value `168.63.129.16`
- `WEBSITE_VNET_ROUTE_ALL` with value `1`

#
```bash
# Create Private Link and Load Balancer first!
az network private-endpoint create --connection-name "xu3ej04u4" \
                                   --name "xu3ej04u4-qa" \
                                   --private-connection-resource-id "/subscriptions/a7bdf2e3-b855-4dda-ac93-047ff722cbbd/resourceGroups/DBA_Test/providers/Microsoft.Network/privateLinkServices/xu3ej04u4" \
                                   --resource-group "DBA_Test" \
                                   --subnet "default" \
                                   --subscription "a7bdf2e3-b855-4dda-ac93-047ff722cbbd" \
                                   --vnet-name "vnet"
                                   #--group-id "/subscriptions/a7bdf2e3-b855-4dda-ac93-047ff722cbbd/resourceGroups/dba_test/providers/Microsoft.Web/sites/xu3ej04u4/slots/qa"
```

# Reference
- [Integrate your app with an Azure virtual network](https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet)