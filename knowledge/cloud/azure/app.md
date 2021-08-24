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

# Reference
- [Integrate your app with an Azure virtual network](https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet)