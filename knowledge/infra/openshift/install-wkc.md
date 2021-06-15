# WKC Install SOP
## Azure 架構
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
        <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-iam-contributor.png">
    - user access administrator
        <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-iam-user-access-admin.png">

## 硬體需求
- VM
    - temporary bootstrap * 1
        - vCPU: 4
        - RAM: 16G
        - storage: 120G
    - control plane * 3
        - vCPU: 4
        - RAM: 16G
        - storage: 120G
    - worker * 3 (最少 2 台，但 2 台會無法安裝，原因未知)
        - vCPU: 2
        - RAM: 8G
        - storage: 120G

## 安裝架構
<br><img src="../../../img/openshift/install-flow.png">

## 到 Azure Portal 進 Console 找出 subscription, tenant, client (appId), client password
- `az ad sp create-for-rbac --role="Contributor" --name="http://corpnet.auo.com" --scopes="/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"`
    ```json
    {
        "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
        "displayName": "corpnet.auo.com",
        "name": "http://corpnet.auo.com",
        "password": "**********************************",
        "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    }
    ```
- `az ad sp list --filter "appId eq 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'"`
- `az role assignment create --role "User Access Administrator" --assignee-object-id "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"`

## 設定 Install Config
```yaml
# install-config.yaml

apiVersion: v1
baseDomain: corpnet.auo.com  # domain name
compute: # worker spec
- architecture: amd64
  hyperthreading: Enabled
  name: worker
  platform:
    azure:
      osDisk:
        diskSizeGB: 300
      type: Standard_D16s_v3
      zones:
      - "1"
  replicas: 4
controlPlane: # master spec
  architecture: amd64
  hyperthreading: Enabled
  name: master
  platform:
    azure:
      osDisk:
        diskSizeGB: 300
      type: Standard_D8s_v3
      zones:
      - "1"
  replicas: 3
metadata:
  creationTimestamp: null
  name: wkc
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  machineNetwork:
  - cidr: 10.250.0.0/16 # Azure VNet IP range
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  azure:
    baseDomainResourceGroupName: WKC
    networkResourceGroupName: Global
    virtualNetwork: VNet # Azure VNet name
    controlPlaneSubnet: AUO-AzureWKCMasterFarm # subnet name
    computeSubnet: AUO-AzureWKCMasterFarm # subnet name
    region: southeastasia
publish: Internal
pullSecret: 'json-format-key' # key from redhat
sshKey: |
  ssh-rsa XXX azadmin@maz-bastion
```

## 前置作業
```bash
# by root

timedatectl set-timezone Asia/Taipei

yum update -y
yum install epel-release -y
yum install htop telnet nc nmap -y
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo
yum install azure-cli -y
```

## 安裝 OpenShift on Bastion VM
- 在 baseDomainResourceGroupName 建立 private DNS zone: wkc.corpnet.auo.com
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_inst
    cd ./ocp4.5_inst
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-install-linux-4.5.36.tar.gz
    tar xvf openshift-install-linux-4.5.36.tar.gz

    cd ~
    mkdir ocp4.5_cust
    cp ./install-config.yaml ./ocp4.5_cust

    cd ~
    ```
- 安裝 OpenShift 所有環境
    - 設定 config
        - `./ocp4.5_inst/openshift-install create install-config --dir=/home/azadmin/ocp4.5_cust`
            ```
            ? SSH Public Key /home/azadmin/.ssh/id_rsa.pub
            ? Platform azure
            ? azure subscription id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (固定)
            ? azure tenant id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (固定)
            ? azure service principal client id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (appId, 固定)
            ? azure service principal client secret **********************************
            ```
    - 安裝 OpenShift (約一小時，若自行設定 DNS，VM 建立時需注意名稱解析)
        - `./ocp4.5_inst/openshift-install create cluster --dir=/home/azadmin/ocp4.5_cust --log-level=info`
            ```
            INFO Credentials loaded from file "/home/azadmin/.azure/osServicePrincipal.json"
            INFO Consuming Install Config from target directory (10 分鐘)
            INFO Creating infrastructure resources... (5 分鐘)
            INFO Waiting up to 20m0s for the Kubernetes API at https://api.dba-k8s.test.org:6443...
            INFO API v1.18.3+cdb0358 up
            INFO Waiting up to 40m0s for bootstrapping to complete... (10 ~ 20 分鐘)
            INFO Destroying the bootstrap resources... (2 分鐘)
            INFO Waiting up to 30m0s for the cluster at https://api.dba-k8s.test.org:6443 to initialize...
            INFO Waiting up to 10m0s for the openshift-console route to be created...
            INFO Install complete!
            INFO To access the cluster as the system:admin user when using 'oc', run 'export KUBECONFIG=/home/azadmin/ocp4.5_cust/auth/kubeconfig'
            INFO Access the OpenShift web-console here: https://console-openshift-console.apps.dba-k8s.test.org
            INFO Login to the console with user: "kubeadmin", and password: "Kxksv-gPsnk-bILsY-7Pqax"
            INFO Time elapsed: 1h3m20s
            ```
        - check installing status
            - `tail -f ./ocp4.5_inst/.openshift_install.log`
        - 如果不是使用 Azure DNS，需動態改 IP
            - Load balancer: Frontend IP configuration
            - VM: Network interface
            - Private DNS zone
            <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/azure-dns.png">
        - fail message: please rebuild
            - time="2021-05-25T21:25:25+08:00" level=fatal msg="failed to fetch Cluster: failed to generate asset \"Cluster\": failed to create cluster: failed to apply Terraform: error(Timeout) from Infrastructure Provider: Copying the VHD to user environment was too slow, and timeout was reached for the success."
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_client
    cd ./ocp4.5_client
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
    tar xvfz openshift-client-linux-4.5.36.tar.gz
    sudo cp ./oc /usr/bin

    # tab completion
    oc completion bash > oc_bash_completion
    sudo cp oc_bash_completion /etc/bash_completion.d/
    ```
- 確認 OpenShift Status
    - 從 web
        - 正式: https://console-openshift-console.apps.wkc.corpnet.auo.com
        - 開發: https://console-openshift-console.apps.wkc-dev.corpnet.auo.com
        - 測試: https://console-openshift-console.apps.dba-k8s.test.org
    - 從 terminal
        - 登入
            - 正式: `oc login https://api.wkc.corpnet.auo.com:6443 -u kubeadmin -p `\``cat ~/ocp4.5_cust/auth/kubeadmin-password`\`
            - 開發: `oc login https://api.wkc-dev.corpnet.auo.com:6443 -u kubeadmin -p `\``cat ~/ocp4.5_cust/auth/kubeadmin-password`\`
            - 測試: `oc login https://api.dba-k8s.test.org:6443 -u kubeadmin -p `\``cat ~/ocp4.5_cust/auth/kubeadmin-password`\`
        - `oc get pod -A | grep -Ev '1/1 .* R|2/2 .* R|3/3 .* R|4/4 .* R|5/5 .* R|6/6 .* R|7/7 .* R' | grep -v 'Completed'`
    - 查詢 kubeadmin 密碼
        - `cat ~/ocp4.5_cust/auth/kubeadmin-password`
    - 改時間
        ```bash
        ssh core@$(oc get nodes | grep master | sed -n '1,1p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ssh core@$(oc get nodes | grep master | sed -n '2,2p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ssh core@$(oc get nodes | grep master | sed -n '3,3p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ssh core@$(oc get nodes | grep worker | sed -n '1,1p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ssh core@$(oc get nodes | grep worker | sed -n '2,2p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ssh core@$(oc get nodes | grep worker | sed -n '3,3p' | awk '{print $1}') 'sudo timedatectl set-timezone Asia/Taipei'
        ```

## 建置 NFS VM
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
        >/data *(rw,sync,no_root_squash)
- 重啟 NFS
    - `systemctl restart nfs-server`

## 安裝 OpenShift Client on NFS VM
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_client
    cd ./ocp4.5_client
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
    tar xvfz openshift-client-linux-4.5.36.tar.gz
    sudo cp ./oc /usr/bin
    ```
- 安裝 k8s incubator
    ```bash
    curl -L -o kubernetes-incubator.zip https://github.com/kubernetes-incubator/external-storage/archive/master.zip
    unzip kubernetes-incubator.zip
    cd external-storage-master/nfs-client/
    ```
- 建立 OpenShift storage (在 container 內的 storage)
    ```bash
    oc login https://api.wkc.corpnet.auo.com:6443 -u kubeadmin -p XXXXX-XXXXX-XXXXX-XXXXX
    oc create namespace openshift-nfs-storage
    oc label namespace openshift-nfs-storage "openshift.io/cluster-monitoring=true"
    oc project openshift-nfs-storage
    NAMESPACE=`oc project -q`
    echo $NAMESPACE
    sudo sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/rbac.yaml
    sudo sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/deployment.yaml
    ```

## 設定 Disk 路徑 on NFS VM
- 建立 OpenShift RBAC
    ```bash
    oc create -f deploy/rbac.yaml
    oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$NAMESPACE:nfs-client-provisioner
    ```
    ```bash
    cd deploy/
    vi deployment.yaml
    #  env:
    #    - name: PROVISIONER_NAME
    #    value: storage.io/nfs <-- change it
    #    - name: NFS_SERVER
    #    value: 10.250.101.6 <-- internal load balancer
    #    - name: NFS_PATH
    #    value: /data <-- change it
    #
    #  volumes:
    #    - name: nfs-client-root
    #    nfs:
    #      server: 10.250.101.6 <-- internal load balancer
    #      path: /data <-- change it
    ```
    ```bash
    vi class.yaml
    #  apiVersion: storage.k8s.io/v1
    #  kind: StorageClass
    #  metadata:
    #    name: managed-nfs-storage
    #  provisioner: storage.io/nfs # or choose another name, must match deployment's env PROVISIONER_NAME'
    #  parameters:
    #    archiveOnDelete: "false"
    ```
- 建立 deploy resource
    ```bash
    oc create -f deploy/class.yaml
    oc create -f deploy/deployment.yaml
    oc create -f deploy/test-claim.yaml

    oc get pods
    oc get pvc
    ```

## 安裝 WKC by Bastion VM
- 下載 CP4D 檔案
    ```bash
    mkdir ~/ibm
    cd ~/ibm
    wget https://github.com/IBM/cpd-cli/releases/download/v3.5.3/cpd-cli-linux-EE-3.5.3.tgz
    tar xzvf cpd-cli-linux-EE-3.5.3.tgz
    ```
- 修改 repo
    ```bash
    export registry_key="<cpd_key>"
    sed -i -e "s/<enter_api_key>/$registry_key/g" ./repo.yaml
    ```
- 下載 lite
    ```bash
    export DOWNLOAD_FOLDER=~/ibm/v3.5.3/lite
    export ASSEMBLY=lite
    mkdir -p $DOWNLOAD_FOLDER

    ./cpd-cli preload-images \
    --repo ./repo.yaml \
    --assembly $ASSEMBLY \
    --download-path=$DOWNLOAD_FOLDER \
    --action download \
    --accept-all-licenses
    ```
- 下載 WKC
    ```bash
    export DOWNLOAD_FOLDER=~/ibm/v3.5.3/wkc
    export ASSEMBLY=wkc
    mkdir -p $DOWNLOAD_FOLDER

    ./cpd-cli preload-images \
    --repo ./repo.yaml \
    --assembly $ASSEMBLY \
    --download-path=$DOWNLOAD_FOLDER \
    --action download \
    --accept-all-licenses
    ```

## 安裝 WKC from Bastion VM to Cluster VM
- 安裝 podman (redhad 用來取代 docker tool 的工具)
    - `yum install podman -y`
- 建立 namespace
    ```bash
    oc login https://api.wkc.corpnet.auo.com:6443 -u kubeadmin -p `cat ~/ocp4.5_cust/auth/kubeadmin-password`
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
- 安裝 lite (control plane)
    - 設定環境變數
        ```bash
        # export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
        export NAMESPACE=zen
        export STORAGE_CLASS=managed-nfs-storage
        export IMAGE_REGISTRY_USER=$(oc whoami)
        export IMAGE_REGISTRY_PASSWORD=$(oc whoami -t)
        export ASSEMBLY=lite
        export VERSION=3.5.3
        export LOAD_FROM=./v3.5.3/$ASSEMBLY/
        ```
    - `cd ~/ibm`
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
        - error
            ```
            2021-06-15 14:19:00.243713197 +0800 CST m=+22.407708366
            Module              |Instance Name   |Status
            0010-infra x86_64   |                |In Progress
                ============================
                |Resource      |Ready   |Total
                |Deployment    |2       |2
                |PVC           |5       |5
                |StateFulSet   |0       |1
                |Job           |1       |3
                |ReplicaSet    |2       |2
                ============================
            0015-setup x86_64   |      |To Be Installed
            0020-core x86_64    |      |To Be Installed
            ```
    - 確認狀態
        - `./cpd-cli status --assembly $ASSEMBLY --namespace $NAMESPACE`
- 安裝 WKC
    - 設定環境變數
        ```bash
        # export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
        export NAMESPACE=zen
        export STORAGE_CLASS=managed-nfs-storage
        export IMAGE_REGISTRY_USER=kubeadmin
        export IMAGE_REGISTRY_PASSWORD=$(oc whoami -t)
        export ASSEMBLY=wkc
        export VERSION=3.5.3
        export LOAD_FROM=./v3.5.3/$ASSEMBLY/
        ```
    - `cd ~/ibm`
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
        --cluster-pull-username=$IMAGE_REGISTRY_USER \
        --cluster-pull-password=$IMAGE_REGISTRY_PASSWORD \
        --cluster-pull-prefix image-registry.openshift-image-registry.svc:5000/$NAMESPACE \
        --latest-dependency \
        --accept-all-licenses \
        --verbose \
        --insecure-skip-tls-verify
        ```
- WKC portal
    - https://zen-cpd-zen.apps.wkc.corpnet.auo.com

## 設定 Machine Config on Bastion VM
- https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=tasks-changing-required-node-settings#node-settings__crio
- 安裝 python 3
    - `yum install python3 -y`
- 設定 CRI-O container
    - 複製 worker 的 crio.conf 到 bastion
        - `scp core@$(oc get nodes | grep worker | head -1 | awk '{print $1}'):/etc/crio/crio.conf /tmp/crio.conf`
    - 編輯 /tmp/crio.conf
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

## 設定 Proxy on Bastion VM
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
- 確認 pods 狀態
    - `oc get pod -A | grep -Ev '1/1 .* R|2/2 .* R|3/3 .* R|4/4 .* R|5/5 .* R|6/6 .* R|7/7 .* R' | grep -v 'Completed'`
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

## 設定 User Managerment on CP4D Portal
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/openshift/wkc-ldap.png">

- https://docs.microsoft.com/zh-tw/system-center/scsm/ad-ds-attribs?view=sc-sm-2019
- sn: 王大明
- givenname: 1312032
- displayName: DM Wang 王大明
- sAMAccountName: dmwang
- department: I200