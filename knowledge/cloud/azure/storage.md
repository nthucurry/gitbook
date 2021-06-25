# Storage
## Troubleshoot
- https://docs.microsoft.com/zh-tw/azure/storage/files/storage-troubleshooting-files-nfs

## How to mount it?
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/storage-file-shared-url.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/storage-mount-on-macos.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/storage-login-info.png">

## Create an NFS share
```bash
# https://www.wintellect.com/using-nfs-with-azure-blob-storage/
az feature register --namespace Microsoft.Storage --name AllowNFSV3
az feature register --namespace Microsoft.Storage --name PremiumHns
```