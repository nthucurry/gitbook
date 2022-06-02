connect-azaccount -subscriptionid "dbbfebd5-9d23-4d79-a0f9-27fda0e78a77" -tenantid "60493364-8017-472a-8ba4-4f7c93e410ce" -UseDeviceAuthentication
$appgw = Get-AzApplicationGateway -ResourceGroupName "Infra" -Name "findarts-waf"
$appgw = Remove-AzApplicationGatewaySslCertificate -ApplicationGateway $appgw -Name "certificate-privatekey.pfx"
$appgw = Set-AzApplicationGateway -ApplicationGateway $appgw