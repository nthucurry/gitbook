- [Troubleshoot](#troubleshoot)
- [How to mount it?](#how-to-mount-it)
- [Create an NFS share](#create-an-nfs-share)
- [Configure object replication when you have access only to the destination account](#configure-object-replication-when-you-have-access-only-to-the-destination-account)

# Troubleshoot
- https://docs.microsoft.com/zh-tw/azure/storage/files/storage-troubleshooting-files-nfs

# How to mount it?
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/storage-file-shared-url.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/storage-mount-on-macos.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/storage-login-info.png">

# Create an NFS share
```bash
# https://www.wintellect.com/using-nfs-with-azure-blob-storage/
az feature register --namespace Microsoft.Storage --name AllowNFSV3
az feature register --namespace Microsoft.Storage --name PremiumHns
```

# [Configure object replication when you have access only to the destination account](https://docs.microsoft.com/en-us/azure/storage/blobs/object-replication-configure?tabs=portal#configure-object-replication-when-you-have-access-only-to-the-destination-account)
If you do not have permissions to the source storage account, then you can configure object replication on the destination account and provide a JSON file that contains the policy definition to another user to create the same policy on the source account. For example, if the source account is **in a different AAD tenant** from the destination account, then you can use this approach to configure object replication.

Keep in mind that you must be assigned the **ARM Contributor role** scoped to the level of the destination storage account or higher in order to create the policy. For more information, see Azure built-in roles in the Azure role-based access control (Azure RBAC) documentation.