- [Azure 架構](#azure-架構)
- [硬體需求](#硬體需求)
- [安裝架構](#安裝架構)
- [到 Azure Portal 進 Console 找出 subscription, tenant, client (appId), client password](#到-azure-portal-進-console-找出-subscription-tenant-client-appid-client-password)
- [設定 Install Config](#設定-install-config)
- [前置作業 on Bastion VM](#前置作業-on-bastion-vm)
- [安裝 OpenShift on Bastion VM](#安裝-openshift-on-bastion-vm)
- [建置 NFS VM](#建置-nfs-vm)
- [安裝 OpenShift Client on NFS VM](#安裝-openshift-client-on-nfs-vm)
- [設定 Disk 路徑 on NFS VM](#設定-disk-路徑-on-nfs-vm)
- [安裝 Command-Line Interface on Bastion VM](#安裝-command-line-interface-on-bastion-vm)
- [建置專案 zen](#建置專案-zen)
    - [安裝 Control Plane (lite)](#安裝-control-plane-lite)
    - [安裝 WKC (Watson Knowledge Catalog)](#安裝-wkc-watson-knowledge-catalog)
- [如果 WKC 安裝失敗](#如果-wkc-安裝失敗)
- [設定 Machine Config on Bastion VM](#設定-machine-config-on-bastion-vm)
- [設定 Proxy on Bastion VM](#設定-proxy-on-bastion-vm)
- [設定 User Managerment on CP4D Portal](#設定-user-managerment-on-cp4d-portal)

# Azure 架構
- resource group
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-insights-overall.png" width="300">
- VM
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-insights-vm.png" width="300">
- network
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-insights-network.png" width="300">
- storage
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-insights-storage.png" width="300">
- other
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-insights-other.png" width="300">
- access control (IAM)
    - contributor
        <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-iam-contributor.png" width=600>
    - user access administrator
        <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-iam-user-access-admin.png" width=600>

# 硬體需求
- temporary bootstrap * 1
    - vCPU: 4
    - RAM: 16G
    - storage: 120G
- control plane * 3
    - vCPU: 4 (8)
    - RAM: 16G (32G)
    - storage: 120G
- worker * 2 (3)
    - vCPU: 2 (16)
    - RAM: 8G (64G)
    - storage: 120G
- https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=planning-system-requirements#rhos-reqs__production

# 安裝架構
<br><img src="../../../img/openshift/install-flow.png" width=700>

# 到 Azure Portal 進 Console 找出 subscription, tenant, client (appId), client password
- `az ad sp create-for-rbac --role="Contributor" --name="http://test.org" --scopes="/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"`
    ```json
    {
        "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
        "displayName": "test.org",
        "name": "http://test.org",
        "password": "**********************************",
        "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    }
    ```
- `az ad sp list --filter "appId eq 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'"`
- `az role assignment create --role "User Access Administrator" --assignee-object-id "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"`

# 設定 Install Config
[install-config.yaml](./config/install-config.yaml)

# 前置作業 on Bastion VM
- `wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/script/1-initial-setting.sh`
- 執行 [1-initial-setting.sh](./script/1-initial-setting.sh)
    - 安裝 azure cli
    - 安裝 openshift install package
    - 產生 ssh key
    - 更新 install-config.yaml 的 pullSecret 和 sshKey
    - 安裝 openshift client tool
    - 安裝 openshift tab completion
- 下載實用 script
    ```bash
    wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/script/login-ocp.sh
    wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/script/check-pod.sh
    wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/script/backup-etcd.sh
    ```

# 安裝 OpenShift on Bastion VM
- 在 baseDomainResourceGroupName 建立 private DNS zone: wkc.test.org
- 執行
    - [2-azure-config.exp](./script/2-azure-config.exp)
    - [3-install-ocp.sh](./script/3-install-ocp.sh)
- 安裝 OpenShift，約一小時，若自行設定 DNS，VM 建立時需注意名稱解析
- 檢查安裝中 log
    - `tail -f ~/ocp4.5_cust/.openshift_install.log`
- 如果不是使用 Azure DNS，需動態改 IP
    - Load balancer: Frontend IP configuration
    - VM: Network interface
    - Private DNS zone
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-dns.png" width=600>
- 確認 OpenShift Status
    - 從 web: https://console-openshift-console.apps.wkc.test.org
    - 從 terminal
        - 登入: [login-ocp.sh](./script/login-ocp.sh)
        - 檢查: [check-pod.sh](./script/check-pod.sh)
    - 查詢 kubeadmin 密碼
        - `cat ~/ocp4.5_cust/auth/kubeadmin-password`
    - 改時間
        ```bash
        ssh -oStrictHostKeyChecking=no core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ssh -oStrictHostKeyChecking=no core@$(oc get nodes | grep worker | sed -n '1,1p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ```

[Back to top](#)
# 建置 NFS VM
- 掛載大容量 disk (by LVM)
    ```bash
    sudo su
    fdisk -l
    pvcreate /dev/sdc
    vgcreate vg /dev/sdc
    vgdisplay vg
    lvcreate -l 262130 -n lv vg
    lvscan
    mkfs.xfs /dev/vg/lv
    fdisk -l
    mkdir /data
    mount /dev/mapper/vg-lv /data
    vi /etc/fstab
    chown azadmin:azadmin /data
    ```
- `wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/script/4-install-nfs.sh`
- 執行 [4-install-nfs.sh](./script/4-install-nfs.sh)
    - 安裝 NFS
    - 設定 NFS config
    - 安裝 openshift client tool
- 安裝 NFS
    ```bash
    sudo yum install nfs-utils -y
    sudo systemctl enable rpcbind
    sudo systemctl enable nfs-server
    sudo systemctl start rpcbind
    sudo systemctl start nfs-server
    ```
- 設定 NFS config
    - `sudo vi /etc/exports`
        ```
        /data *(rw,sync,no_root_squash)
        ```
- 重啟 NFS
    - `systemctl restart nfs-server`

# 安裝 OpenShift Client on NFS VM
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_client
    cd ./ocp4.5_client
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
    tar xvfz openshift-client-linux-4.5.36.tar.gz
    sudo cp ./oc /usr/bin
    ```
- 安裝 K8S incubator
    ```bash
    curl -L -o kubernetes-incubator.zip https://github.com/kubernetes-incubator/external-storage/archive/master.zip
    unzip kubernetes-incubator.zip
    ```
- 建立 OpenShift storage (在 container 內的 storage)
    ```bash
    oc login https://api.wkc.test.org:6443 -u kubeadmin -p XXXXX-XXXXX-XXXXX-XXXXX
    oc create namespace openshift-nfs-storage
    oc label namespace openshift-nfs-storage "openshift.io/cluster-monitoring=true"
    oc project openshift-nfs-storage

    NAMESPACE=`oc project -q`
    echo $NAMESPACE
    cd external-storage-master/nfs-client/
    sudo sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/rbac.yaml
    sudo sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/deployment.yaml
    ```

# 設定 Disk 路徑 on NFS VM
- 建立 OpenShift RBAC
    ```bash
    oc create -f deploy/rbac.yaml
    oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$NAMESPACE:nfs-client-provisioner
    ```
    ```yaml
    # vi deploy/deployment.yaml
    env:
      - name: PROVISIONER_NAME
      value: storage.io/nfs # <-- change it
      - name: NFS_SERVER
      value: 10.250.101.6 # <-- NFS
      - name: NFS_PATH
      value: /data # <-- change it

    volumes:
      - name: nfs-client-root
      nfs:
        server: 10.250.101.6 # <-- NFS
        path: /data # <-- change it
    ```
    ```yaml
    # vi deploy/class.yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: managed-nfs-storage
    provisioner: storage.io/nfs # or choose another name, must match deployment's env PROVISIONER_NAME'
    parameters:
      archiveOnDelete: "false"
    ```
- 建立 deploy resource
    ```bash
    oc create -f deploy/class.yaml
    oc create -f deploy/deployment.yaml
    oc create -f deploy/test-claim.yaml

    oc get pods
    oc get pvc
    ```

# 安裝 Command-Line Interface on Bastion VM
```bash
# 安裝 cpd-cli
mkdir ~/ibm
cd ~/ibm
wget https://github.com/IBM/cpd-cli/releases/download/v3.5.3/cpd-cli-linux-EE-3.5.3.tgz
tar xzvf cpd-cli-linux-EE-3.5.3.tgz

# 設定 cpd key
export registry_key="<cpd_key>"
sed -i -e "s/<entitlement key>/$registry_key/g" ./repo.yaml
```

# 建置專案 zen
- 建立 namespace
    ```bash
    oc login https://api.wkc.test.org:6443 -u kubeadmin -p `cat ~/ocp4.5_cust/auth/kubeadmin-password`
    oc new-project zen
    ```
- 產生 image registry 的 default route
    ```bash
    cd ~/ibm/v3.5.3
    oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
    ```
- 登入 docker registry
    ```bash
    export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
    sudo podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false $REGISTRY
    ```

[Back to top](#)
## 安裝 Control Plane (lite)
- `cd ~/ibm`
- 設定環境變數
    ```bash
    export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
    export NAMESPACE=zen
    export STORAGE_CLASS=managed-nfs-storage
    export IMAGE_REGISTRY_USER=$(oc whoami)
    export IMAGE_REGISTRY_PASSWORD=$(oc whoami -t)
    export ASSEMBLY=lite
    export VERSION=v3.5.3
    export LOAD_FROM=~/ibm/$VERSION/$ASSEMBLY/
    export DOWNLOAD_FOLDER=~/ibm/$VERSION/$ASSEMBLY/
    ```
- 下載 lite
    ```bash
    mkdir -p $DOWNLOAD_FOLDER

    ./cpd-cli preload-images \
    --repo ./repo.yaml \
    --assembly $ASSEMBLY \
    --download-path=$DOWNLOAD_FOLDER \
    --action download \
    --accept-all-licenses
    ```
- 下載必備檔案
    ```bash
    ./cpd-cli preload-images \
    --assembly $ASSEMBLY \
    --action push \
    --target-registry-username kubeadmin \
    --target-registry-password $IMAGE_REGISTRY_PASSWORD \
    --load-from $LOAD_FROM \
    --transfer-image-to $REGISTRY/$NAMESPACE \
    --insecure-skip-tls-verify \
    --accept-all-licenses
    ```
- 設定 control plane 參數
    ```bash
    ./cpd-cli adm \
    --assembly $ASSEMBLY \
    --latest-dependency \
    --namespace $NAMESPACE \
    --load-from $LOAD_FROM \
    --apply \
    --verbose \
    --accept-all-licenses
    ```
- 安裝
    ```bash
    ./cpd-cli install \
    --assembly $ASSEMBLY \
    --namespace $NAMESPACE \
    --storageclass $STORAGE_CLASS \
    --load-from $LOAD_FROM \
    --cluster-pull-username=kubeadmin \
    --cluster-pull-password=$IMAGE_REGISTRY_PASSWORD \
    --cluster-pull-prefix image-registry.openshift-image-registry.svc:5000/$NAMESPACE \
    --latest-dependency \
    --accept-all-licenses \
    --verbose \
    --insecure-skip-tls-verify
    ```
- 確認狀態
    - `~/ibm/cpd-cli status --assembly lite --namespace zen`

## 安裝 WKC (Watson Knowledge Catalog)
- `cd ~/ibm`
- 設定環境變數
    ```bash
    export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
    export NAMESPACE=zen
    export STORAGE_CLASS=managed-nfs-storage
    export IMAGE_REGISTRY_USER=kubeadmin
    export IMAGE_REGISTRY_PASSWORD=$(oc whoami -t)
    export ASSEMBLY=wkc
    export VERSION=v3.5.3
    export LOAD_FROM=~/ibm/$VERSION/$ASSEMBLY/
    export DOWNLOAD_FOLDER=~/ibm/$VERSION/$ASSEMBLY/
    ```
- 下載 WKC
    ```bash
    mkdir -p $DOWNLOAD_FOLDER

    ./cpd-cli preload-images \
    --repo ./repo.yaml \
    --assembly $ASSEMBLY \
    --download-path=$DOWNLOAD_FOLDER \
    --action download \
    --accept-all-licenses
    ```
- 避免 504 錯誤
    - `oc annotate route default-route default-route --overwrite haproxy.router.openshift.io/timeout=10m -n openshift-image-registry`
- 下載必備檔案
    ```bash
    ./cpd-cli preload-images \
    --assembly $ASSEMBLY \
    --action push \
    --target-registry-username $IMAGE_REGISTRY_USER \
    --target-registry-password $IMAGE_REGISTRY_PASSWORD \
    --load-from $LOAD_FROM \
    --transfer-image-to $REGISTRY/$NAMESPACE \
    --insecure-skip-tls-verify \
    --accept-all-licenses
    ```
- 設定參數
    ```bash
    ./cpd-cli adm \
    --assembly $ASSEMBLY \
    --latest-dependency \
    --namespace $NAMESPACE \
    --load-from $LOAD_FROM \
    --apply \
    --verbose \
    --accept-all-licenses
    ```
- 安裝
    ```bash
    ./cpd-cli install \
    --assembly $ASSEMBLY \
    --namespace $NAMESPACE \
    --storageclass $STORAGE_CLASS \
    --load-from $LOAD_FROM \
    --cluster-pull-username=$IMAGE_REGISTRY_USER \
    --cluster-pull-password=$IMAGE_REGISTRY_PASSWORD \
    --cluster-pull-prefix image-registry.openshift-image-registry.svc:5000/$NAMESPACE \
    --latest-dependency \
    --accept-all-licenses \
    --verbose \
    --insecure-skip-tls-verify
    ```
- 確認狀態
    - `~/ibm/cpd-cli status --assembly wkc --namespace zen`
- WKC portal
    - https://zen-cpd-zen.apps.wkc.test.org

[Back to top](#)
# 如果 WKC 安裝失敗
- 檢查 pod 狀態
    - 出現 ErrImagePull 與 ImagePullBackOff，皆表示無法取得映像檔
    - 查看詳細資料內 Event 的內容
        - `oc describe pods iis-xmetarepo-5b54fbfd7-qckmj`
- 刪除 project，重裝 WKC
    - `oc delete project zen`
    - [安裝 WKC from Bastion VM to Cluster VM](#安裝-wkc-from-bastion-vm-to-cluster-vm)

# 設定 Machine Config on Bastion VM
- [CRI-O container settings](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=tasks-changing-required-node-settings#node-settings__crio)
- 安裝 python 3
    - `sudo yum install python3 -y`
- 設定 CRI-O container
    - 複製 worker 的 crio.conf 到 bastion
        - `scp core@$(oc get nodes | grep worker | head -1 | awk '{print $1}'):/etc/crio/crio.conf /tmp/crio.conf`
    - `vi /tmp/crio.conf`
        ```
        default_ulimits = [
                "nofile=66560:66560"
        ]
        pids_limit = 12288
        ```
    - 設定環境變數
        - `crio_conf=$(cat /tmp/crio.conf | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(''.join(sys.stdin.readlines())))")`
    - 建立 machine config
        ```yaml
        cat << EOF > /tmp/51-worker-cp4d-crio-conf.yaml
        apiVersion: machineconfiguration.openshift.io/v1
        kind: MachineConfig
        metadata:
         labels:
           machineconfiguration.openshift.io/role: worker
         name: 51-worker-cp4d-crio-conf
        spec:
         config:
           ignition:
             version: 2.2.0
           storage:
             files:
             - contents:
                 source: data:,${crio_conf}
               filesystem: root
               mode: 0644
               path: /etc/crio/crio.conf
        EOF
        ```
    - 執行 oc 使參數生效，此時 worker 會重啟，約花 30 分鐘
        - `oc create -f /tmp/51-worker-cp4d-crio-conf.yaml`
        - 確認執行進度
            - `watch "oc get nodes"`
    - 檢查參數
        - `oc exec is-en-conductor-0 -- bash -c "cat /sys/fs/cgroup/pids/pids.max"`
- 設定 kernel parameter
    - 編輯 yaml
        ```yaml
        apiVersion: tuned.openshift.io/v1
        kind: Tuned
        metadata:
          name: cp4d-wkc-ipc
          namespace: openshift-cluster-node-tuning-operator
        spec:
          profile:
          - name: cp4d-wkc-ipc
            data: |
              [main]
              summary=Tune IPC Kernel parameters on OpenShift Worker Nodes running WKC Pods
              [sysctl]
              kernel.shmall = 33554432
              kernel.shmmax = 68719476736
              kernel.shmmni = 32768
              kernel.sem = 250 1024000 100 32768
              kernel.msgmax = 65536
              kernel.msgmnb = 65536
              kernel.msgmni = 32768
              vm.max_map_count = 262144
          recommend:
          - match:
            - label: node-role.kubernetes.io/worker
            priority: 10
            profile: cp4d-wkc-ipc
        ```
    - 執行 oc 使參數生效
        - `oc create -f 42-cp4d.yaml`

[Back to top](#)
# 設定 Proxy on Bastion VM
- 設定 NSG
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-nsg.png">
- 編輯 proxy object
    - `oc edit proxy/cluster`
        ```yaml
        apiVersion: config.openshift.io/v1
        kind: Proxy
        metadata:
            name: cluster
        spec:
            httpProxy: http://10.250.12.5:3128
            httpsProxy: http://10.250.12.5:3128
        ```
- proxy 連線清單
    ```
    mirror.openshift.com
    quay.io
    stry.redhat.io
    sso.redhat.com
    openshift.org
    cert-api.access.redhat.com
    api.access.redhat.com
    api.openshift.com
    infogw.api.openshift.com
    cloud.redhat.com
    management.azure.com
    ```

# 設定 User Managerment on CP4D Portal
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/wkc-ldap.png">

- https://docs.microsoft.com/zh-tw/system-center/scsm/ad-ds-attribs?view=sc-sm-2019
- sn: 王大明
- givenname: 1312032
- displayName: DM Wang 王大明
- sAMAccountName: dmwang
- department: I200