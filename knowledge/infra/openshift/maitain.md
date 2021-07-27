- [重點概念](#重點概念)
- [Azure](#azure)
- [OpenShift](#openshift)
    - [Creating a Self-Signed SSL Certificate for your Intranet Services](#creating-a-self-signed-ssl-certificate-for-your-intranet-services)
        - [Replacing the default ingress certificate](#replacing-the-default-ingress-certificate)
    - [調整 worker 數量](#調整-worker-數量)
    - [未整理筆記](#未整理筆記)
- [備份](#備份)
    - [OpenShift](#openshift-1)
        - [Backing up etcd](#backing-up-etcd)
    - [WKC (CP4D)](#wkc-cp4d)
        - [Backing up and restoring your project](#backing-up-and-restoring-your-project)
        - [Installing the CPD backup and restore service](#installing-the-cpd-backup-and-restore-service)
            - [Backup and restore service PVC](#backup-and-restore-service-pvc)
            - [Repository secret](#repository-secret)
        - [Install the cpdbr Docker image](#install-the-cpdbr-docker-image)
        - [Backing up the CPD file system to a local repository or object store](#backing-up-the-cpd-file-system-to-a-local-repository-or-object-store)
        - [Schedule job](#schedule-job)
        - [Restoring the CPD file system from a local repository or object store](#restoring-the-cpd-file-system-from-a-local-repository-or-object-store)
        - [Migrating Cloud Pak for Data metadata and clusters](#migrating-cloud-pak-for-data-metadata-and-clusters)
        - [Install the cpdtool Docker image by using Podman](#install-the-cpdtool-docker-image-by-using-podman)
        - [Install the zen-core-aux Docker image by using Podman](#install-the-zen-core-aux-docker-image-by-using-podman)
        - [Install the zen-core-aux Helm chart](#install-the-zen-core-aux-helm-chart)
        - [Initialize the export-import command](#initialize-the-export-import-command)
- [維運](#維運)
    - [大型維運](#大型維運)
        - [[用不到] ~~Shutting down the cluster~~](#用不到-shutting-down-the-cluster)
        - [Restarting the cluster gracefully](#restarting-the-cluster-gracefully)
        - [Disaster Recovery](#disaster-recovery)
    - [日常維運](#日常維運)
        - [Replacing an unhealthy etcd member](#replacing-an-unhealthy-etcd-member)
        - [Replacing the unhealthy etcd member (未完成...)](#replacing-the-unhealthy-etcd-member-未完成)
    - [Alert Mail (TBD)](#alert-mail-tbd)

# 重點概念
- OpenShift cluster 不需備份 VM，因為已經是 cluster 架構了，壞了在透過 yaml rebuild 就好
    - 嚴格說起來，一台 Master VM 也可以執行 WKC
- 需要備份的是 Bastion VM，因為上面有 ssh key、kubeadm 密碼
- etcd 備份到 storage account

# Azure
- WKC 資源若被 delete，會 auto-rebuild，但不可靠
- Recovery Services Vault (保存庫)
    - Geo-redundant storage (GRS, 異地備援儲存體)
        <br><img src="https://docs.microsoft.com/zh-tw/azure/storage/common/media/storage-redundancy/geo-redundant-storage.png">
    - 定期備份 Bastion、NFS VM
        - 一天一次，保留最近三天
        - WKC cluster 缺少 VM agent，無法備份
- SLA for Virtual Machines
    - For any Single VM using Premium SSD or Ultra Disk for all OS Disks and Data Disks, we guarantee you will have VM Connectivity of at least 99.9%. (一年最多停機 8.76 小時)
- NFS
    ```bash
    subscription_id="de61f224-9a69-4ede-8273-5bcef854dc20"
    az feature register --namespace Microsoft.Storage --name AllowNFSV3 --subscription $subscription_id
    az feature register --namespace Microsoft.Storage --name PremiumHns --subscription $subscription_id

    # check
    subscription_id="de61f224-9a69-4ede-8273-5bcef854dc20"
    az feature show --namespace Microsoft.Storage --name AllowNFSV3 --subscription $subscription_id
    ```
- 開機自動掛載 NFS
    - `chmod +x /etc/rc.d/rc.local`
    - `vi /etc/rc.d/rc.local`
        ```bash
        mkdir -p /mnt/backup/etcd
        mount -o sec=sys,vers=3,nolock,proto=tcp wkcnfs.blob.core.windows.net:/wkcnfs/etcd /mnt/backup/etcd

        mkdir -p /mnt/backup/config
        mount -o sec=sys,vers=3,nolock,proto=tcp wkcnfs.blob.core.windows.net:/wkcnfs/config /mnt/backup/config
        ```
    - 參考: [mount-aznfs.sh](./script/mount-aznfs.sh)

# OpenShift
## Creating a Self-Signed SSL Certificate for your Intranet Services
可參考保哥文章: [如何使用 OpenSSL 建立開發測試用途的自簽憑證 (Self-Signed Certificate)](https://blog.miniasp.com/post/2019/02/25/Creating-Self-signed-Certificate-using-OpenSSL)

### Replacing the default ingress certificate
- 建立 ssl.conf 設定檔: `vi ssl.conf`
    ```
    [req]
    prompt = no
    default_md = sha256
    default_bits = 2048
    distinguished_name = dn
    x509_extensions = v3_req

    [dn]
    C = TW
    ST = Taiwan
    L = Taipei
    O = Test Inc.
    OU = IT Department
    emailAddress = admin@example.com
    CN = localhost

    [v3_req]
    subjectAltName = @alt_names

    [alt_names]
    DNS.1 = *.apps.dba-k8s.test.org
    DNS.2 = api.dba-k8s.test.org
    ```
- 產生自簽憑證與相對應的私密金鑰
    - `openssl req -x509 -new -nodes -sha256 -utf8 -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt -config ssl.conf`
    - 請注意：上述命令會建立一個「未加密」的私密金鑰檔案，使用 PEM 格式輸出。
- 透過 OpenSSL 命令產生 PKCS#12 憑證檔案 (使用時，需密碼)
    - `openssl pkcs12 -export -in server.crt -inkey server.key -out server.pfx`
- 在 bastion 設定憑證
    ```bash
    oc create configmap custom-ca \
        --from-file=ca-bundle.crt=/home/azadmin/ssl/server.crt \
        -n openshift-config

    oc patch proxy/cluster \
        --type=merge \
        --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'

    oc create secret tls my-tls-migration \
        --cert=/home/azadmin/ssl/server.crt \
        --key=/home/azadmin/ssl/server.key \
        -n openshift-ingress

    oc patch ingresscontroller.operator default \
        --type=merge -p \
        '{"spec":{"defaultCertificate": {"name": "my-tls-migration"}}}' \
        -n openshift-ingress-operator
    ```
- 匯入自簽憑證到「受信任的根憑證授權單位」
    <br><img src="../../../img/security/root-cert-step-1.png" width=500>
    <br><img src="../../../img/security/root-cert-step-2.png" width=500>
    <br><img src="../../../img/security/root-cert-step-3.png" width=500>
    <br><img src="../../../img/security/root-cert-step-4.png" width=500>
    <br><img src="../../../img/security/root-cert-step-5.png" width=250>
- 從 pfx 匯出 crt (or cer)
    - `openssl pkcs12 -in server.pfx -nokeys -password "pass:ncu5540" -out - 2>/dev/null | openssl x509 -out server.crt`
    - `openssl pkcs12 -in server.pfx -nocerts -password "pass:ncu5540" -nodes -out server.key`

## 調整 worker 數量
1. View the machine sets that are in the cluster
    - `oc get machinesets -n openshift-machine-api`
2. Scale the machine set
    - `oc scale --replicas=2 machineset <machineset> -n openshift-machine-api`
    - `oc edit machineset <machineset> -n openshift-machine-api`

## 未整理筆記
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

[Back to top](#)
# 備份
## OpenShift
- https://docs.openshift.com/container-platform/4.5/backup_and_restore/backing-up-etcd.html

### Backing up etcd
The etcd is the key-value store for OCP, which persists the state of all resource objects.
1. Start a debug session for a master node
    - `oc debug node/<node_name>`
2. Change your root directory to the host
    - `chroot /host`
3. If the cluster-wide proxy is enabled, be sure that you have exported the NO_PROXY, HTTP_PROXY, and HTTPS_PROXY environment variables
4. Run the cluster-backup.sh script and pass in the location to save the backup to
    `/usr/local/bin/cluster-backup.sh /home/core/assets/backup`

## WKC (CP4D)
### Backing up and restoring your project
You can back up and restore the **Persistent Volumes (PVs)** in a project (namespace) in your IBM® Cloud Pak for Data file system.

The following table describes the components and services that support backup and restore by using volume snapshots, volume backups, or a separate process.

### [Installing the CPD backup and restore service](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=project-installing-backup-restore-service)
#### Backup and restore service PVC
- [不使用] ~~Creating a PVC from a PV on an NFS file system~~
- Creating a PVC from a storage class of bastion VM
    - 建立 NFS volumn yaml: [cpdbr-pvc.yaml](./config/cpdbr-pvc.yaml)
    - `oc apply -f cpdbr-pvc.yaml -n zen`

#### Repository secret
If you are backing up and restoring volumes to and from a local repository or object store, you **must create a repository secret** that is named cpdbr-repo-secret before you can initialize the service.
```bash
echo -n 'restic' > RESTIC_PASSWORD
oc create secret generic -n zen cpdbr-repo-secret \
    --from-file=./RESTIC_PASSWORD
```

### Install the cpdbr Docker image
```bash
IMAGE_REGISTRY=`oc get route -n openshift-image-registry | grep image-registry | awk '{print $2}'`
echo $IMAGE_REGISTRY
NAMESPACE=`oc project -q`
echo $NAMESPACE
CPU_ARCH=`uname -m`
echo $CPU_ARCH
BUILD_NUM=`~/ibm/cpd-cli backup-restore version | grep "Build Number" | cut -d : -f 2 | xargs`
echo $BUILD_NUM

# Pull cpdbr image from Docker Hub
sudo podman pull docker.io/ibmcom/cpdbr:2.0.0-${BUILD_NUM}-${CPU_ARCH}
# Push image to internal registry
sudo podman login -u kubeadmin -p $(oc whoami -t) $IMAGE_REGISTRY --tls-verify=false
sudo podman tag docker.io/ibmcom/cpdbr:2.0.0-${BUILD_NUM}-${CPU_ARCH} $IMAGE_REGISTRY/$NAMESPACE/cpdbr:2.0.0-${BUILD_NUM}-${CPU_ARCH}
sudo podman push $IMAGE_REGISTRY/$NAMESPACE/cpdbr:2.0.0-${BUILD_NUM}-${CPU_ARCH} --tls-verify=false
```
- View the version of the backup and restore service
    - `~/ibm/cpd-cli backup-restore version`

### [Backing up the CPD file system to a local repository or object store](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=bu-backing-up-file-system-local-repository-object-store)
- **Initialize cpd-cli backup-restore** (執行一次就好)
    ```bash
    ~/ibm/cpd-cli backup-restore init \
    --namespace zen \
    --pvc-name cpdbr-pvc \
    --image-prefix=image-registry.openshift-image-registry.svc:5000/zen \
    --provider=local

    # Command started, processing...
    # Command executed successfully
    ```
- **Manually scale down K8S** (停下 zen pod 約 10 分鐘)
    - `~/ibm/cpd-cli backup-restore quiesce -n zen`
- Check for completed jobs and pods
    - `~/ibm/cpd-cli backup-restore volume-backup create -n zen --dry-run cpdbk-2021-0716`
    - If the dry run reports completed or failed jobs, or pods, that reference PVCs, delete them
- **Run the backup command** (約 10 分鐘)
    - `~/ibm/cpd-cli backup-restore volume-backup create -n zen cpdbk-2021-0716 --skip-quiesce=true`
- **Manually scale up K8S**
    - `~/ibm/cpd-cli backup-restore unquiesce -n zen`
- Check the status of a backup job
    - `~/ibm/cpd-cli backup-restore volume-backup status -n zen cpdbk-2021-0716`
        ```
        Name:           cpdbk-2021-0716
        Job Name:       cpdbr-bu-cpdbk-2021-0716
        Active:         0
        Succeeded:      1
        Failed:         0
        Start Time:     Fri, 16 Jul 2021 08:27:25 +0800
        Completed At:   Fri, 16 Jul 2021 08:32:54 +0800
        Duration:       5m29s
        ```
- View a list of existing volume backups
    - `~/ibm/cpd-cli backup-restore volume-backup list -n zen`
        ```
        NAME            CREATED AT              LAST BACKUP
        cpdbk-2021-0716 2021-07-16T00:27:29Z    2021-07-16T00:32:53Z
        ```
- Get the logs of a volume backup
    - `~/ibm/cpd-cli backup-restore volume-backup logs -n zen cpdbk-2021-0716`

### Schedule job
- [cronjob.txt](./config/cronjob.txt)
- [backup-wkc.sh](./script/backup-wkc.sh)

### Restoring the CPD file system from a local repository or object store
The process to restore the persistent volumes (PVs) that are associated with your IBM Cloud Pak for Data project depends on the storage provider that you are using.
- ~~Initialize cpd-cli backup-restore~~
- **Manually scale down K8S** (停下 zen pod 約 10 分鐘)
    - `~/ibm/cpd-cli backup-restore quiesce -n zen`
- Check for completed jobs and pods
    - `~/ibm/cpd-cli backup-restore volume-restore create --from-backup cpdbk-2021-0716 -n zen --dry-run cpdbk-2021-0716`
- **Run the restore command** (約 30 分鐘)
    - `~/ibm/cpd-cli backup-restore volume-restore create --from-backup cpdbk-2021-0716 -n zen cpdbk-2021-0716 --skip-quiesce=true`
- **Manually scale up application Kubernetes resources** (約 20 分鐘)
    - `~/ibm/cpd-cli backup-restore unquiesce -n zen`

### [Migrating Cloud Pak for Data metadata and clusters](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=cluster-migrating-cloud-pak-data-metadata-clusters)
- Creates an NFS volume named zen-pvc
    ```bash
    cat << EOF | tee ~/config/zen-pvc.yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
    name: zen-pvc
    spec:
    storageClassName: managed-nfs-storage
    accessModes:
        - ReadWriteMany
    resources:
        requests:
        storage: 200Gi
    EOF
    ```
    - `oc apply -f zen-pvc.yaml`

### Install the cpdtool Docker image by using Podman
```bash
IMAGE_REGISTRY=`oc get route -n openshift-image-registry | grep image-registry | awk '{print $2}'`
echo $IMAGE_REGISTRY
NAMESPACE=`oc project -q`
echo $NAMESPACE
CPU_ARCH=`uname -m`
echo $CPU_ARCH
BUILD_NUM=`~/ibm/cpd-cli export-import version | grep "Build Number" | cut -d : -f 2 | xargs`
echo $BUILD_NUM

# Pull cpdtool image from Docker Hub
sudo podman pull docker.io/ibmcom/cpdtool:2.0.0-${BUILD_NUM}-${CPU_ARCH}
# Push image to internal registry
sudo podman login -u kubeadmin -p $(oc whoami -t) $IMAGE_REGISTRY --tls-verify=false
sudo podman tag docker.io/ibmcom/cpdtool:2.0.0-${BUILD_NUM}-${CPU_ARCH} $IMAGE_REGISTRY/$NAMESPACE/cpdtool:2.0.0-${BUILD_NUM}-${CPU_ARCH}
sudo podman push $IMAGE_REGISTRY/$NAMESPACE/cpdtool:2.0.0-${BUILD_NUM}-${CPU_ARCH} --tls-verify=false
```

### Install the zen-core-aux Docker image by using Podman
```bash
IMAGE_REGISTRY=`oc get route -n openshift-image-registry | grep image-registry | awk '{print $2}'`
echo $IMAGE_REGISTRY
NAMESPACE=`oc project -q`
echo $NAMESPACE
CPU_ARCH=`uname -m`
echo $CPU_ARCH
BUILD_NUM=`~/ibm/cpd-cli export-import version | grep "Build Number" | cut -d : -f 2 | xargs`
echo $BUILD_NUM

# Pull zen-core-aux image from Docker Hub
sudo podman pull docker.io/ibmcom/zen-core-aux:2.0.0-${BUILD_NUM}-${CPU_ARCH}
# Push image to internal registry
sudo podman login -u kubeadmin -p $(oc whoami -t) $IMAGE_REGISTRY --tls-verify=false
sudo podman tag docker.io/ibmcom/zen-core-aux:2.0.0-${BUILD_NUM}-${CPU_ARCH} $IMAGE_REGISTRY/$NAMESPACE/zen-core-aux:2.0.0-${BUILD_NUM}-${CPU_ARCH}
sudo podman push $IMAGE_REGISTRY/$NAMESPACE/zen-core-aux:2.0.0-${BUILD_NUM}-${CPU_ARCH} --tls-verify=false
```

### Install the zen-core-aux Helm chart
- Download the Helm chart zen-core-aux-2.0.0.tgz
    - `wget https://github.com/IBM/cpd-cli/raw/master/cpdtool/2.0.0/x86_64/zen-core-aux-2.0.0.tgz`
- Copy the Helm chart to the cpd-install-operator pod
- Install the chart by using Helm
    ```bash
    # Delete any existing zen-core-aux-exim configmaps
    oc delete cm cpd-zen-aux-zen-core-aux-exim-cm
    oc delete cm zen-core-aux-exim-cm
    # Find the cpd-install-operator pod
    oc get po | grep cpd-install
    cpd-install-operator-84bb575c7c-s67f7
    # Copy the helm chart to the pod
    oc cp zen-core-aux-2.0.0.tgz cpd-install-operator-84bb575c7c-s67f7:/tmp/zen-core-aux-2.0.0.tgz
    # Inside the pod, run helm install
    oc rsh cpd-install-operator-84bb575c7c-s67f7
    cd tmp
    helm install zen-core-aux-2.0.0.tgz --name zen-core-aux --tls
    ```

### Initialize the export-import command
- `cpd-cli export-import init --namespace zen --arch $(uname -m) --pvc-name zen-pvc --profile=default --image-prefix=image-registry.openshift-image-registry.svc:5000/zen --profile=default`

[Back to top](#)
# 維運
## 大型維運
### [用不到] ~~Shutting down the cluster~~
### Restarting the cluster gracefully
### Disaster Recovery

## 日常維運
### Replacing an unhealthy etcd member
- Check the status of the EtcdMembersAvailable status condition using the following command
    - `oc get etcd -o=jsonpath='{range .items[0].status.conditions[?(@.type=="EtcdMembersAvailable")]}{.message}{"\n"}'`
- Review the output
    - 好: 3 members are available
    - 壞: 2 of 3 members are available, ip-10-0-131-183.ec2.internal is unhealthy

### [Replacing the unhealthy etcd member](https://docs.openshift.com/container-platform/4.5/backup_and_restore/replacing-unhealthy-etcd-member.html#replacing-the-unhealthy-etcd-member) (未完成...)
-  Replacing an unhealthy etcd member whose machine is not running or whose node is not ready
    1. Remove the unhealthy member.

## Alert Mail (TBD)
- 從 log 抓 successfully... 等字串
- 若無符合，mail 通知