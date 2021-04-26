# WKC Install SOP
## Azure 架構
<br><img src="../../../img/openshift/azure-insights-overall.png" width="500">
<br><img src="../../../img/openshift/azure-insights-vm.png">
<br><img src="../../../img/openshift/azure-insights-network.png">
<br><img src="../../../img/openshift/azure-insights-storage.png">
<br><img src="../../../img/openshift/azure-insights-other.png">

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
apiVersion: v1
baseDomain: corpnet.auo.com
compute:
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
controlPlane:
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
  - cidr: 10.250.0.0/16
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  azure:
    baseDomainResourceGroupName: WKC
    networkResourceGroupName: Global
    virtualNetwork: VNet
    controlPlaneSubnet: AUO-AzureWKCMasterFarm
    computeSubnet: AUO-AzureWKCMasterFarm
    region: southeastasia
publish: Internal
pullSecret: 'json-format-key'
sshKey: |
  ssh-rsa XXX azadmin@maz-bastion
```

## 安裝 OpenShift on Bastion VM
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_inst
    cd ./ocp4.5_inst
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-install-linux-4.5.36.tar.gz
    tar xvf openshift-install-linux-4.5.36.tar.gz

    mkdir ocp4.5_cust
    cp ./install-config.yaml ./ocp4.5_cust
    ```
- 安裝 WKC 所有環境
    - 設定 config
        - `./ocp4.5_inst/openshift-install create install-config --dir=/home/azadmin/ocp4.5_cust`
            ```txt
            ? SSH Public Key /home/azadmin/.ssh/id_rsa.pub
            ? Platform azure
            ? azure subscription id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
            ? azure tenant id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
            ? azure service principal client id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
            ? azure service principal client secret [? for help] **********************************
            ```
    - 安裝 WKC (約一小時，若自行設定 DNS，VM 建立時需注意名稱解析)
        - `./ocp4.5_inst/openshift-install create cluster --dir=/home/azadmin/ocp4.5_cust --log-level=info`
        - check installing status
            - `tail -f ./ocp4.5_inst/.openshift_install.log`
    - 確認 OpenShift Status
        - 從 web
            - https://console-openshift-console.apps.wkc.corpnet.auo.com
        - 從 terminal
            - `oc login https://api.wkc.corpnet.auo.com:6443 -u kubeadmin -p XXXXX-XXXXX-XXXXX-XXXXX`
            - `oc get pod -A | grep -Ev '1/1 .* R|2/2 .* R|3/3 .* R|4/4 .* R|5/5 .* R|6/6 .* R|7/7 .* R' | grep -v 'Completed'`
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_client
    cd ./ocp4.5_client
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
    tar xvfz openshift-client-linux-4.5.36.tar.gz
    sudo cp ./oc /usr/bin
    ```

## 安裝 OpenShift Client on NFS VM
- 修改 repo
    ```bash
    export registry_key="<key>"
    sed -i -e "s/<enter_api_key>/$registry_key/g" ./repo.yaml
    ```
- 下載 OpenShift 檔案
    ```bash
    cd ~
    mkdir ocp4.5_client
    cd ./ocp4.5_client
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
    tar xvfz openshift-client-linux-4.5.36.tar.gz
    sudo cp ./oc /usr/bin
    ```
- 下載 CP4D 檔案
    ```bash
    mkdir ~/ibm
    cd ~/ibm
    wget https://github.com/IBM/cpd-cli/releases/download/v3.5.3/cpd-cli-linux-EE-3.5.3.tgz
    tar xzvf cpd-cli-linux-EE-3.5.3.tgz
    ```
- 下載 lite
    ```bash
    export DOWNLOAD_FOLDER=~/ibm/v3.5.3/lite
    mkdir -p $DOWNLOAD_FOLDER
    export ASSEMBLY=lite
    ./cpd-cli preload-images --repo ./repo.yaml --assembly $ASSEMBLY --download-path=$DOWNLOAD_FOLDER --action download --accept-all-licenses
    ```
- 下載 WKC
    ```bash
    export DOWNLOAD_FOLDER=~/ibm/v3.5.3/wkc
    mkdir -p $DOWNLOAD_FOLDER
    export ASSEMBLY=wkc
    ./cpd-cli preload-images --repo ./repo.yaml --assembly $ASSEMBLY --download-path=$DOWNLOAD_FOLDER --action download --accept-all-licenses
    ```
- 掛載大容量 disk
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
    sudo yum install -y nfs-utils
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
- 安裝 OpenShift Container Platform
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
- 建立 OpenShift storage (在 container 內的 storage ?)
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
    #    value: storage.io/nfs
    #    - name: NFS_SERVER
    #    value: 10.250.101.6
    #    - name: NFS_PATH
    #    value: /data
    #
    #  volumes:
    #    - name: nfs-client-root
    #    nfs:
    #      server: 10.250.101.6
    #      path: /data
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
- oc
    ```bash
    oc create -f deploy/class.yaml
    oc create -f deploy/deployment.yaml
    oc create -f deploy/test-claim.yaml

    oc get pods
    oc get pvc
    ```
- 安裝 podman (redhad 取代 docker tool)
    - `yum install podman -y`
- 建立 Namespace
    ```bash
    oc login https://api.wkc.corpnet.auo.com:6443 -u kubeadmin -p XXXXX-XXXXX-XXXXX-XXXXX
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
- 安裝 lite
    - 設定環境變數
        ```bash
        export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
        export NAMESPACE=zen
        export STORAGE_CLASS=managed-nfs-storage
        export IMAGE_REGISTRY_USER=$(oc whoami)
        export IMAGE_REGISTRY_PASSWORD=$(oc whoami -t)
        export ASSEMBLY=lite
        export VERSION=3.5.3
        export LOAD_FROM=./v3.5.3/lite
        ```
    - 執行 cpd cli
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

        ./cpd-cli adm \
        --assembly $ASSEMBLY \
        --latest-dependency \
        --namespace $NAMESPACE \
        --load-from $LOAD_FROM \
        --apply \
        --verbose \
        --accept-all-licenses

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
        - `./cpd-cli status --assembly $ASSEMBLY --namespace $NAMESPACE`
- 安裝 WKC
    - 設定環境變數
        ```bash
        export REGISTRY=`oc get route default-route -n openshift-image-registry --template="{{ .spec.host }}"`
        export NAMESPACE=zen
        export STORAGE_CLASS=managed-nfs-storage
        export IMAGE_REGISTRY_USER=kubeadmin
        export IMAGE_REGISTRY_PASSWORD=$(oc whoami -t)
        export ASSEMBLY=wkc
        export VERSION=3.5.3
        export LOAD_FROM=./v3.5.3/wkc/
        ```
    - 執行 cpd cli
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

        ./cpd-cli adm \
        --assembly $ASSEMBLY \
        --latest-dependency \
        --namespace $NAMESPACE \
        --load-from $LOAD_FROM \
        --apply \
        --verbose \
        --accept-all-licenses

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

## 設定 Proxy
- 設定 NSG
    <br><img src="../../../img/openshift/azure-nsg.png">
- 編輯 Proxy object
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