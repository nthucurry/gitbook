- [Upgrade OpenShift](#upgrade-openshift)
- [Setting up install variables](#setting-up-install-variables)
- [Upgrade cpd-cli version](#upgrade-cpd-cli-version)
- [Obtaining your IBM entitlement API key](#obtaining-your-ibm-entitlement-api-key)
- [Setting up projects (namespaces) on Red Hat OpenShift Container Platform (Upgrading from Version 3.5)](#setting-up-projects-namespaces-on-red-hat-openshift-container-platform-upgrading-from-version-35)
  - [Mirroring images to your private container registry](#mirroring-images-to-your-private-container-registry)
  - [Configuring your cluster to pull Cloud Pak for Data images](#configuring-your-cluster-to-pull-cloud-pak-for-data-images)
  - [Configuring an image content source policy](#configuring-an-image-content-source-policy)
- [Cloud Pak for Data (lite)](#cloud-pak-for-data-lite)
  - [Creating catalog sources that pull specific versions of images from the IBM Entitled Registry (Upgrading from Version 3.5)](#creating-catalog-sources-that-pull-specific-versions-of-images-from-the-ibm-entitled-registry-upgrading-from-version-35)
  - [Installing or upgrading IBM Cloud Pak foundational services](#installing-or-upgrading-ibm-cloud-pak-foundational-services)
  - [Creating operator subscriptions before upgrading from Version 3.5](#creating-operator-subscriptions-before-upgrading-from-version-35)
  - [Creating custom security context constraints for services before upgrading from Version 3.5](#creating-custom-security-context-constraints-for-services-before-upgrading-from-version-35)
  - [Changing required node settings before upgrading from Version 3.5](#changing-required-node-settings-before-upgrading-from-version-35)
  - [Installing Cloud Pak for Data](#installing-cloud-pak-for-data)
  - [Specifying the install plan for operators that are automatically installed by Operand Deployment Lifecycle Manager](#specifying-the-install-plan-for-operators-that-are-automatically-installed-by-operand-deployment-lifecycle-manager)
  - [Integrating with the IAM Service](#integrating-with-the-iam-service)
  - [Making monitoring data highly available](#making-monitoring-data-highly-available)
  - [Changing the route to the platform](#changing-the-route-to-the-platform)
  - [Configuring an external route to the Flight service](#configuring-an-external-route-to-the-flight-service)
  - [Securing communication ports](#securing-communication-ports)
  - [Setting up the Cloud Pak for Data web client](#setting-up-the-cloud-pak-for-data-web-client)
- [Watson Knowledge Catalog (wkc)](#watson-knowledge-catalog-wkc)
  - [Fixing the productVersion value for specific releases](#fixing-the-productversion-value-for-specific-releases)
  - [(略) Sizing and scaling up the XMETA data store portion of your InfoSphere® Information Server Db2® instance](#略-sizing-and-scaling-up-the-xmeta-data-store-portion-of-your-infosphere-information-server-db2-instance)
  - [Determining which upgrade method to use for your environment](#determining-which-upgrade-method-to-use-for-your-environment)
  - [Setting the values of your Watson Knowledge Catalog data store](#setting-the-values-of-your-watson-knowledge-catalog-data-store)
  - [Upgrading the service](#upgrading-the-service)
  - [Verifying the upgrade](#verifying-the-upgrade)
  - [Updating column character limit (known issue)](#updating-column-character-limit-known-issue)
  - [(略) Running the XMETA data store backup and restore](#略-running-the-xmeta-data-store-backup-and-restore)
  - [Resizing the PersistentVolumeClaim (PVC)](#resizing-the-persistentvolumeclaim-pvc)
  - [Update the indexes in the XMETA database](#update-the-indexes-in-the-xmeta-database)
  - [Verifying the status](#verifying-the-status)

# [Upgrade OpenShift](https://docs.openshift.com/container-platform/4.5/updating/updating-cluster-cli.html#update-upgrading-cli_updating-cluster-cli)
- Install the jq package
    - `yum install jq -y`
- Ensure that your cluster is available
    - `oc get clusterversion`
- Confirm that your channel is set to stable-4.5
    - `oc get clusterversion -o json | jq ".items[0].spec"`
- View the available updates that you want to apply
    - `oc adm upgrade`
- Apply an update
    - `oc adm upgrade --to-latest=true`
    - `oc adm upgrade --to=<version>`
- Review the status of the Cluster Version Operator
    - `oc get clusterversion -o json | jq ".items[0].spec"`
- Review the cluster version status history to monitor the status of the update
    - `oc get clusterversion -o json | jq ".items[0].status.history"`
- Confirm the cluster version
    - `oc get clusterversion`

# [Setting up install variables](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=installing-best-practice-setting-up-install-variables)
- `source cpd_vars.sh`
    - [cpd_vars.sh](./script/cpd_vars.sh)

# Upgrade cpd-cli version
```bash
curl -sLkO https://github.com/IBM/cpd-cli/releases/download/v3.5.8/cpd-cli-linux-EE-3.5.8.tgz
tar xzvf ./cpd-cli-linux-EE-3.5.8.tgz
```

# [Obtaining your IBM entitlement API key](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-obtaining-your-entitlement-api-key)

# [Setting up projects (namespaces) on Red Hat OpenShift Container Platform (Upgrading from Version 3.5)](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=upgrade-setting-up-projects-namespaces)
- Create the appropriate projects for your environment
    ```bash
    oc new-project ${PROJECT_CPFS_OPS}
    oc new-project ${PROJECT_CPD_OPS}
    oc new-project ${PROJECT_CPD_INSTANCE}
    # oc new-project ${PROJECT_TETHERED}
    ```
- Create the appropriate operator groups based on the type of installation method you are using
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: operators.coreos.com/v1alpha2
    kind: OperatorGroup
    metadata:
      name: operatorgroup
      namespace: ${PROJECT_CPFS_OPS}
    spec:
      targetNamespaces:
      - ${PROJECT_CPFS_OPS}
    EOF
    ```

[Back to top](#)
## [Mirroring images to your private container registry](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-mirroring-images-your-private-container-registry)
- Downloading and installing the software needed to mirror images
    - OpenShift CLI (本來就會有)
    - IBM Cloud Pak CLI (cloudctl)
    - httpd-tools
        - `yum install httpd-tools`

## [Configuring your cluster to pull Cloud Pak for Data images](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-configuring-your-cluster-pull-images#preinstall-cluster-setup__pull-secret)
- Configuring the global image pull secret
- Download the pull secret to the temporary directory
    ```bash
    oc get secret/pull-secret \
        -n openshift-config \
        --template='{{index .data ".dockerconfigjson" | base64decode}}' > ${WORK_ROOT}/global_pull_secret.cfg
    ```
- Add the new pull secret to the local copy of the global_pull_secret.cfg file
    - IBM Entitled Registry
        ```bash
        oc registry login \
            --registry="${IBM_ENTITLEMENT_SERVER}" \
            --auth-basic="${IBM_ENTITLEMENT_USER}:${IBM_ENTITLEMENT_KEY}" \
            --to=${WORK_ROOT}/global_pull_secret.cfg
        ```
    - Private container registry
        ```bash
        oc registry login \
            --registry="${PRIVATE_REGISTRY_LOCATION}" \
            --auth-basic="${PRIVATE_REGISTRY_PULL_USER}:${PRIVATE_REGISTRY_PULL_PASSWORD}" \
            --to=${WORK_ROOT}/global_pull_secret.cfg
        ```
- Update the global pull secret on your cluster
    ```bash
    oc set data secret/pull-secret \
        -n openshift-config \
        --from-file=.dockerconfigjson=${WORK_ROOT}/global_pull_secret.cfg
    ```
- Get the status of the nodes

[Back to top](#)
## Configuring an image content source policy
- Create an image content source policy
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: operator.openshift.io/v1alpha1
    kind: ImageContentSourcePolicy
    metadata:
      name: cloud-pak-for-data-mirror
    spec:
      repositoryDigestMirrors:
      - mirrors:
        - ${PRIVATE_REGISTRY_LOCATION}/cp
        source: cp.icr.io/cp
      - mirrors:
        - ${PRIVATE_REGISTRY_LOCATION}/cp/cpd
        source: cp.icr.io/cp/cpd
      - mirrors:
        - ${PRIVATE_REGISTRY_LOCATION}/cpopen
        source: icr.io/cpopen
      - mirrors:
        - ${PRIVATE_REGISTRY_LOCATION}/db2u
        source: icr.io/db2u
      - mirrors:
        - ${PRIVATE_REGISTRY_LOCATION}/guardium-insights
        source: icr.io/guardium-insights
    EOF
    ```
- Verify that the image content source policy was created
    - `oc get imageContentSourcePolicy`

[Back to top](#)
# Cloud Pak for Data (lite)
## [Creating catalog sources that pull specific versions of images from the IBM Entitled Registry (Upgrading from Version 3.5)](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=ccs-creating-catalog-sources-that-pull-specific-versions-images-from-entitled-registry-1)
- Preparing your system
    - Installing Python
        ```bash
        yum install python3 -y
        alternatives --set python /usr/bin/python3
        # ln -s /usr/bin/python3 /usr/bin/python
        # rm /usr/bin/python
        pip3 install PyYAML
        pip3 install argparse
        ```
    - Installing IBM Cloud Pak CLI (cloudctl)
        ```bash
        wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz
        tar -xzf cloudctl-linux-amd64.tar.gz
        chmod 775 cloudctl-linux-amd64
        mv cloudctl-linux-amd64 /usr/local/bin/cloudctl
        cloudctl --help
        ```
- Downloading the CASE packages
    ```bash
    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-cp-datacore \
        --version 2.0.13 \
        --outputdir ${OFFLINEDIR_CPD} \
        --no-dependency

    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-cp-common-services \
        --version 1.13.0 \
        --outputdir ${OFFLINEDIR_CPFS}

    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-cpd-scheduling \
        --version 1.3.4 \
        --outputdir ${OFFLINEDIR_CPD}

    # 自己加的
    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-wkc \
        --version 4.0.8 \
        --outputdir ${OFFLINEDIR_CPD}

    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-db2aaservice \
        --version 4.0.10 \
        --outputdir ${OFFLINEDIR_CPD}

    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-iis \
        --version 4.0.8 \
        --outputdir ${OFFLINEDIR_CPD}
    ```
- To create the catalog source
    - Create the IBM Cloud Pak foundational services catalog source **(ibm-cp-common-services)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPFS}/ibm-cp-common-services-1.13.0.tgz \
            --inventory ibmCommonServiceOperatorSetup \
            -n ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--registry icr.io --inputDir ${OFFLINEDIR_CPFS} --recursive"

        # Verify that ibm-cpd-scheduling-catalog is READY
        oc get catalogsource -n ${PROJECT_CATSRC} ibm-cpd-scheduling-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
    - Create the scheduling service catalog source **(ibm-cpd-scheduling)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cpd-scheduling-1.3.4.tgz \
            --inventory schedulerSetup \
            -n ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--inputDir ${OFFLINEDIR_CPD} --recursive"

        # Verify that ibm-cpd-scheduling-catalog is READY
        oc get catalogsource -n ${PROJECT_CATSRC} ibm-cpd-scheduling-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
    - Create the IBM Cloud Pak for Data catalog source **(ibm-cp-datacore)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
            --inventory cpdPlatformOperator \
            -n ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--inputDir ${OFFLINEDIR_CPD} --recursive"

        # Verify that cpd-platform is READY
        oc get catalogsource -n ${PROJECT_CATSRC} cpd-platform -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
    - (略) Create the Db2U catalog source if you plan to upgrade or install one of the following services
    - Create the Watson Knowledge Catalog catalog source **(ibm-wkc)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-wkc-4.0.8.tgz \
            --inventory wkcOperatorSetup \
            -n ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--inputDir ${OFFLINEDIR_CPD} --recursive"

        # Verify that ibm-cpd-wkc-operator-catalog is READY
        oc get catalogsource -n ${PROJECT_CATSRC} ibm-cpd-wkc-operator-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```

## [Installing or upgrading IBM Cloud Pak foundational services](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=upgrade-installing-upgrading-cloud-pak-foundational-services)
- Create the appropriate operator subscription for your environment
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: operators.coreos.com/v1alpha1
    kind: Subscription
    metadata:
      name: ibm-common-service-operator
      namespace: ${PROJECT_CPFS_OPS}
    spec:
      channel: v3
      installPlanApproval: Automatic
      name: ibm-common-service-operator
      source: opencloud-operators
      sourceNamespace: ${PROJECT_CATSRC}
    EOF
    ```

## [Creating operator subscriptions before upgrading from Version 3.5](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=upgrade-creating-operator-subscriptions)
- (略) Creating an operator subscription for the scheduling service
- Creating an operator subscription for the IBM Cloud Pak for Data platform operator
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: operators.coreos.com/v1alpha1
    kind: Subscription
    metadata:
      name: cpd-operator
      namespace: ${PROJECT_CPD_OPS}
    spec:
      channel: v2.0
      installPlanApproval: ${APPROVAL_TYPE}
      name: cpd-platform-operator
      source: cpd-platform
      sourceNamespace: ${PROJECT_CATSRC}
    EOF

    # Verify that the command returns cpd-platform-operator.v2.0.8
    oc get sub -n ${PROJECT_CPD_OPS} cpd-operator -o jsonpath='{.status.installedCSV} {"\n"}'

    # Verify that the command returns Succeeded : install strategy completed with no errors
    oc get csv -n ${PROJECT_CPD_OPS} cpd-platform-operator.v2.0.8 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

    # Verify that the command returns an integer greater than or equal to 1
    oc get deployments -n ${PROJECT_CPD_OPS} -l olm.owner="cpd-platform-operator.v2.0.8" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
    ```
- (略) Enabling services to use namespace scoping with third-party operators
- Creating an operator subscription for services
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: operators.coreos.com/v1alpha1
    kind: Subscription
    metadata:
    labels:
        app.kubernetes.io/instance:  ibm-cpd-wkc-operator-catalog-subscription
        app.kubernetes.io/managed-by: ibm-cpd-wkc-operator
        app.kubernetes.io/name:  ibm-cpd-wkc-operator-catalog-subscription
    name: ibm-cpd-wkc-operator-catalog-subscription
    namespace: ${PROJECT_CPD_OPS}
    spec:
        channel: v1.0
        installPlanApproval: ${APPROVAL_TYPE}
        name: ibm-cpd-wkc
        source: ibm-cpd-wkc-operator-catalog
        sourceNamespace: ${PROJECT_CATSRC}
    EOF

    # Verify that the command returns ibm-cpd-wkc.v1.0.8
    oc get sub -n ${PROJECT_CPD_OPS} ibm-cpd-wkc-operator-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'

    # Verify that the command returns Succeeded : install strategy completed with no errors
    oc get csv -n ${PROJECT_CPD_OPS} ibm-cpd-wkc.v1.0.8 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

    # Verify that the command returns an integer greater than or equal to 1
    oc get deployments -n ${PROJECT_CPD_OPS} -l olm.owner="ibm-cpd-wkc.v1.0.8" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
    ```

## [Creating custom security context constraints for services before upgrading from Version 3.5](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=upgrade-creating-custom-sccs)
- To create the SCC **(wkc-iis-scc)**
    ```bash
    cat << EOF | oc apply -f -
    allowHostDirVolumePlugin: false
    allowHostIPC: false
    allowHostNetwork: false
    allowHostPID: false
    allowHostPorts: false
    allowPrivilegeEscalation: true
    allowPrivilegedContainer: false
    allowedCapabilities: null
    apiVersion: security.openshift.io/v1
    defaultAddCapabilities: null
    fsGroup:
      type: RunAsAny
    kind: SecurityContextConstraints
    metadata:
      annotations:
        kubernetes.io/description: WKC/IIS provides all features of the restricted SCC
          but runs as user 10032.
      name: wkc-iis-scc
    readOnlyRootFilesystem: false
    requiredDropCapabilities:
    - KILL
    - MKNOD
    - SETUID
    - SETGID
    runAsUser:
      type: MustRunAs
      uid: 10032
    seLinuxContext:
      type: MustRunAs
    supplementalGroups:
      type: RunAsAny
    volumes:
    - configMap
    - downwardAPI
    - emptyDir
    - persistentVolumeClaim
    - projected
    - secret
    users:
    - system:serviceaccount:${PROJECT_CPD_INSTANCE}:wkc-iis-sa
    EOF
    ```
- Verify that the SCC was created
- Create the SCC cluster role for wkc-iis-scc
- Assign the wkc-iis-sa service account to the SCC cluster role
- Confirm that the wkc-iis-sa service account can use the wkc-iis-scc SCC

## [Changing required node settings before upgrading from Version 3.5](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=upgrade-changing-required-node-settings)
- ~~Load balancer timeout settings (Azure 自己有 Load Balancer))~~
- CRI-O container settings
- Kernel parameter settings
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: machineconfiguration.openshift.io/v1
    kind: KubeletConfig
    metadata:
      name: db2u-kubelet
    spec:
      machineConfigPoolSelector:
        matchLabels:
          db2u-kubelet: sysctl
      kubeletConfig:
        allowedUnsafeSysctls:
          - "kernel.msg*"
          - "kernel.shm*"
          - "kernel.sem"
    EOF
    ```

## [Installing Cloud Pak for Data](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=installing-cloud-pak-data)
- Enable the IBM Cloud Pak for Data platform operator and the IBM Cloud Pak foundational services operator to watch the project where you will install IBM Cloud Pak for Data
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: operator.ibm.com/v1alpha1
    kind: OperandRequest
    metadata:
      name: empty-request
      namespace: ${PROJECT_CPD_INSTANCE}
    spec:
      requests: []
    EOF
    ```
- Create a custom resource to install Cloud Pak for Data **(The cluster uses NFS storage)**
    ```bash
    cat << EOF | oc apply -f -
    apiVersion: cpd.ibm.com/v1
    kind: Ibmcpd
    metadata:
        name: ibmcpd-cr
        namespace: ${PROJECT_CPD_INSTANCE}
        csNamespace: ${PROJECT_CPFS_OPS}
    spec:
        license:
        accept: true
        license: ${LICENSE_CPD}
        storageClass: managed-nfs-storage
    EOF

    # Now using project "zen" on server "https://api.wkc-dev.corpnet.auo.com:6443"
    oc project ${PROJECT_CPD_INSTANCE}

    # Verifying the installation: Completed
    oc get Ibmcpd ibmcpd-cr -o jsonpath="{.status.controlPlaneStatus}{'\n'}"
    oc get ZenService lite-cr -o jsonpath="{.status.zenStatus}{'\n'}"
    ```

## [Specifying the install plan for operators that are automatically installed by Operand Deployment Lifecycle Manager](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-specifying-install-plan-automatically-installed-operators)
- Choosing an upgrade plan for the Cloud Pak for Data control plane
    ```bash
    oc patch ZenService lite-cr \
        -n ${PROJECT_CPD_INSTANCE} \
        --type=merge \
        --patch '{"spec": {"version":"4.4.3"}}'

    # Wait for the command to return Completed
    oc get ZenService lite-cr -n ${PROJECT_CPD_INSTANCE} -o jsonpath="{.status}"
    ```

## [Integrating with the IAM Service](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-integrating-iam-service)
## [Making monitoring data highly available](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-making-monitoring-data-highly-available)
## [Changing the route to the platform](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-changing-route-platform)
## [Configuring an external route to the Flight service](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-configuring-external-route-flight-service)
## [Securing communication ports](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-securing-communication-ports)
## Setting up the Cloud Pak for Data web client

[Back to top](#)
# Watson Knowledge Catalog (wkc)
> Rolling back the upgrade is **not supported** when upgrading from the Version 3.5 release to a Version 4.0.x release.

## Fixing the productVersion value for specific releases
## (略) Sizing and scaling up the XMETA data store portion of your InfoSphere® Information Server Db2® instance
## Determining which upgrade method to use for your environment
- Offline upgrade (XMETA data store is larger than 500 GB)
- Online upgrade (default, XMETA data store is smaller than 500 GB)

## Setting the values of your Watson Knowledge Catalog data store
> If you are using NFS for storage, **skip this part** of the upgrade procedure. If you are using Red Hat OpenShift Container Storage or Portworx, you must complete the steps in this part of the upgrade procedure.

## Upgrading the service
```bash
cat << EOF | oc apply -f -
apiVersion: wkc.cpd.ibm.com/v1beta1
kind: WKC
metadata:
  name: wkc-cr     # This is the recommended name, but you can change it
  namespace: ${PROJECT_CPD_INSTANCE}
spec:
  license:
    accept: true
    license: ${LICENSE_CPD}
  version: 4.0.8
  storageClass: managed-nfs-storage          # If you use a different storage class, replace it with the appropriate storage class
  # wkc_db2u_set_kernel_params: True
  # iis_db2u_set_kernel_params: True
  # install_wkc_core_only: true     # To install the core version of the service, remove the comment tagging from the beginning of the line.
EOF
```

## Verifying the upgrade
```bash
# ./check-wkc.sh

export namespace=zen

# Lite
oc get cm zen-lite-operation-configmap -n $namespace -o jsonpath='{.data.operation}{"\n"}'
# CCS
oc get ccs ccs-cr -n $namespace -o jsonpath='{.status.ccsUpgradeStatus}' | awk '{print $NF}'
# DR
oc get DataRefinery datarefinery-sample -n $namespace  -o jsonpath="{.status.datarefineryUpgradeStatus}"; echo
# DB2u
oc get Db2aaserviceService db2aaservice-cr -n $namespace -o jsonpath="{.status.db2aaserviceStatus}"; echo
# IIS
oc get iis iis-cr -n $namespace -o jsonpath="{.status.iisUpgradeStatus}"; echo
# UG
oc get ug ug-cr -n $namespace -o jsonpath="{.status.ugUpgradeStatus}"; echo
# WKC (Overall CR status)
oc get wkc wkc-cr -n $namespace -o jsonpath="{.status.wkcUpgradeStatus}"; echo
```

## Updating column character limit (known issue)
## (略) Running the XMETA data store backup and restore
## Resizing the PersistentVolumeClaim (PVC)
## Update the indexes in the XMETA database
- Download
    - `wget https://www.ibm.com/support/pages/node/6481667#:~:text=dq_manage_indices.zip`
- Copy the scripts from the attached ZIP file to the c-db2oltp-iis-db2u-0 pod
    - `oc cp dq_manage_indices.sh c-db2oltp-iis-db2u-0:/tmp/dq_manage_indices.sh`
    - `oc cp dq_create_indices.sql c-db2oltp-iis-db2u-0:/tmp/dq_create_indices.sql`
    - `oc cp dq_drop_indices.sql c-db2oltp-iis-db2u-0:/tmp/dq_drop_indices.sql`
- Log on to the Db2U pod
    - `oc rsh c-db2oltp-iis-db2u-0 bash`
- Run the script to the update the indexes in the XMETA database
    - `cd /tmp/`
    - `chmod 755 dq*.*`
    - `./dq_manage_indices.sh`

## Verifying the status
```bash
# CCS
oc get ccs ccs-cr -n zen
# DR
oc get datarefinery datarefinery-sample -n zen
# DB2u
oc get Db2aaserviceService db2aaservice-cr -n zen
# IIS
oc get IIS iis-cr -n zen
oc get ZenService lite-cr -n zen
# UG
oc get UG ug-cr -n zen
# WKC (Overall CR status)
oc get WKC wkc-cr -n zen
```