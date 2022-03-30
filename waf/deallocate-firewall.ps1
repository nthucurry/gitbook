$resourceGroup = "DBA-K8S"
$location = "Southeast Asia"
$vnet = "t-vnet"
$firewall = "fortiweb-fw"
$firewallPublicIP = "fortiweb-fw"

# Stop an existing firewall
$azfw = Get-AzFirewall -Name $firewall -ResourceGroupName $resourceGroup
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Start the firewall
$azfw = Get-AzFirewall -Name $firewall -ResourceGroupName $resourceGroup
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnet
$pip = Get-AzPublicIpAddress -Name $firewallPublicIP -ResourceGroupName $resourceGroup
$azfw.Allocate($vnet, $pip)
Set-AzFirewall -AzureFirewall $azfw