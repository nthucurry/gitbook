# Stop an existing firewall
$azfw = Get-AzFirewall -Name "fortiweb" -ResourceGroupName "DBA-K8S"
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Start the firewall
$azfw = Get-AzFirewall -Name "fortiweb" -ResourceGroupName "DBA-K8S"
$vnet = Get-AzVirtualNetwork -ResourceGroupName "DBA-K8S" -Name "t-vnet"
$publicip1 = Get-AzPublicIpAddress -Name "fortiweb-t-web" -ResourceGroupName "DBA-K8S"
$publicip2 = Get-AzPublicIpAddress -Name "fortiweb-t-zbx" -ResourceGroupName "DBA-K8S"
$azfw.Allocate($vnet,@($publicip1,$publicip2))
Set-AzFirewall -AzureFirewall $azfw