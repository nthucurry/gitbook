# Storage
## Troubleshoot
- https://docs.microsoft.com/zh-tw/azure/storage/files/storage-troubleshooting-files-nfs

## How to mount it?
<br><img src="../../../img/cloud/azure/storage-file-shared-url.png">
<br><img src="../../../img/cloud/azure/storage-mount-on-macos.png">
<br><img src="../../../img/cloud/azure/storage-login-info.png">

## Create an NFS share
```powershell
Connect-AzAccount

$yourSubscriptionIDHere = ""
$context = Get-AzSubscription -SubscriptionId $yourSubscriptionIDHere
Set-AzContext $context

Register-AzProviderFeature -FeatureName AllowNfsFileShares -ProviderNamespace Microsoft.Storage

Register-AzResourceProvider -ProviderNamespace Microsoft.Storage
```