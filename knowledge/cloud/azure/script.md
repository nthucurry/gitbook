# Azure Command & SOP
- =~ allows case insensitive matching

## Count virtual machines by OS type
```bash
az graph query -q "Resources | where type =~ 'Microsoft.Compute/virtualMachines' | summarize count() by tostring(properties.storageProfile.osDisk.osType)"
```

## 更新 ssh key
- [Reset SSH Keys](https://docs.bitnami.com/azure/faq/troubleshooting/troubleshoot-ssh-keys/)
    - ![](../../../img/cloud/azure/reset-ssh-key.png)