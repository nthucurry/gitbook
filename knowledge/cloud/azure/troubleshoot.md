# Troubleshoot
## VNet integration
In native Windows apps, the tools ping, nslookup, and tracert **won't work** through the console because of security constraints (they work in custom **Windows containers**). To fill the void, two separate tools are added. To test DNS functionality, we added a tool named nameresolver.exe.
https://docs.microsoft.com/zh-tw/azure/app-service/web-sites-integrate-with-vnet
- tcpping
    <br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/cloud/azure/app-tcpping.png?raw=true">