# Maintain List
## 重點概念
- OpenShift cluster 不需備份 VM，因為已經是 cluster 架構了，壞了在透過 yaml rebuild 就好
    - 嚴格說起來，一台 Master VM 也可以執行 WKC
- 需要備份的是 Bastion VM，因為上面有 ssh key、kubeadm 密碼
- etcd 備份到 storage account

## Azure
- WKC 資源若被 delete，會 auto-rebuild
- Recovery Services Vault (保存庫)
    - Geo-redundant storage (GRS, 異地備援儲存體)
        <br><img src="https://docs.microsoft.com/zh-tw/azure/storage/common/media/storage-redundancy/geo-redundant-storage.png">
    - 定期備份 Bastion、NFS VM
        - 一天一次，保留最近三天
        - WKC cluster 缺少 VM agent，無法備份
- SLA for Virtual Machines
    <br>For any Single VM using Premium SSD or Ultra Disk for all OS Disks and Data Disks, we guarantee you will have VM Connectivity of at least 99.9%. (一年最多停機 8.76 小時)
- NFS
    ```bash
    subscription_id="de61f224-9a69-4ede-8273-5bcef854dc20"
    az feature register --namespace Microsoft.Storage --name AllowNFSV3 --subscription $subscription_id

    # check
    subscription_id="de61f224-9a69-4ede-8273-5bcef854dc20"
    az feature show --namespace Microsoft.Storage --name AllowNFSV3 --subscription $subscription_id
    ```

## OpenShift
### 沒開機不能 Login
```bash
oc login https://api.dba-k8s.azure.org:6443 -u kubeadmin -p `cat ~/ocp4.5_cust/auth/kubeadmin-password`
```
error: dial tcp 10.0.10.5:6443: connect: no route to host - verify you have provided the correct host and port and that the server is currently running.


```bash
ssh core@$node sudo shutdown -h now
nodes=$(oc get nodes -ojsonpath='{​​​​​​​​.items[*].metadata.name}​​​​​​​​')

# 重啟 Worker 步驟
https://docs.openshift.com/container-platform/4.5/nodes/nodes/nodes-nodes-working.html
oc adm cordon <worker-node>
oc adm drain <worker-node> --ignore-daemonsets --force=true --delete-local-data=true

ssh core@NODE_NAME
sudo -i
systemctl stop kubelet
systemctl stop crio
systemctl reboot

oc adm uncordon <worker-node>
```

## 備份
### OpenShift
- https://docs.openshift.com/container-platform/4.5/backup_and_restore/backing-up-etcd.html

#### Backing up etcd
- etcd is the key-value store for OCP, which persists the state of all resource objects.
1. Start a debug session for a master node
    >oc debug node/<node_name>
2. Change your root directory to the host
    >chroot /host
3. If the cluster-wide proxy is enabled, be sure that you have exported the NO_PROXY, HTTP_PROXY, and HTTPS_PROXY environment variables
4. Run the cluster-backup.sh script and pass in the location to save the backup to
    >/usr/local/bin/cluster-backup.sh /home/core/assets/backup

### WKC (CP4D)

## 維運
### 大型維運
#### Shutting down the cluster
#### Restarting the cluster gracefully
#### Disaster Recovery

### 日常維運
#### Replacing an unhealthy etcd member
- Check the status of the EtcdMembersAvailable status condition using the following command
    >oc get etcd -o=jsonpath='{range .items[0].status.conditions[?(@.type=="EtcdMembersAvailable")]}{.message}{"\n"}'
- Review the output
    - 好: 3 members are available
    - 壞: 2 of 3 members are available, ip-10-0-131-183.ec2.internal is unhealthy

#### (Replacing the unhealthy etcd member)[https://docs.openshift.com/container-platform/4.5/backup_and_restore/replacing-unhealthy-etcd-member.html#replacing-the-unhealthy-etcd-member] (未完成...)
-  Replacing an unhealthy etcd member whose machine is not running or whose node is not ready
    1. Remove the unhealthy member.