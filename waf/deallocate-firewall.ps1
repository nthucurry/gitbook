# Stop an existing firewall
$azfw = Get-AzFirewall -Name "t-fw" -ResourceGroupName "DBA-K8S"
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Start the firewall

$azfw = Get-AzFirewall -Name "t-fw" -ResourceGroupName "DBA-K8S"
$vnet = Get-AzVirtualNetwork -ResourceGroupName "DBA-K8S" -Name "t-vnet"
$pip= Get-AzPublicIpAddress -ResourceGroupName "DBA-K8S" -Name "t-fw"
# $mgmtPip2 = Get-AzPublicIpAddress -ResourceGroupName "DBA-K8S" -Name "mgmtpip"
# $azfw.Allocate($vnet, $pip, $mgmtPip2)
$azfw.Allocate($vnet, $pip)
$azfw | Set-AzFirewall