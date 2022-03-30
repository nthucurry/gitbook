$resourceGroup = "DBA-K8S"
$location = "Southeast Asia"
$vnet = "t-vnet"
$firewall = "fortiweb-fw"

# Stop an existing firewall
$azfw = Get-AzFirewall -Name $firewall -ResourceGroupName $resourceGroup
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Start the firewall
$azfw = Get-AzFirewall -Name $firewall -ResourceGroupName $resourceGroup
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnet
$pip1 = Get-AzPublicIpAddress -Name "fortiweb-fw" -ResourceGroupName $resourceGroup
$pip2 = Get-AzPublicIpAddress -Name "fortiweb-t-web" -ResourceGroupName $resourceGroup
$azfw.Allocate($vnet,@($pip1,$pip2))
Set-AzFirewall -AzureFirewall $azfw