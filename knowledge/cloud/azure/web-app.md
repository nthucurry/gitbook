# SSH session to a Linux container in Azure App Service
```bash
resource_group="DBA_Test"
app_name="ui-web-test"
az webapp create-remote-connection --resource-group $resource_group -n cfa-ui-web-official-test
apt-get install traceroute
apt-get install telnet
```