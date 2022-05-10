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

- Environment variable
    ```bash
    export OFFLINEDIR_CPD=$HOME/offline/cpd
    export OFFLINEDIR_CPFS=$HOME/offline/cpfs
    export PATH_CASE_REPO=https://github.com/IBM/cloud-pak/raw/master/repo/case
    export PROJECT_CATSRC=openshift-marketplace
    mkdir -p $OFFLINEDIR_CPD
    ```
- Downloading the CASE packages
    ```bash
    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-cp-datacore \
        --version 2.0.13 \
        --outputdir ${OFFLINEDIR_CPD} \
        --no-dependency

    mkdir -p $OFFLINEDIR_CPFS
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

    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-watson-ks \
        --version 4.0.7 \
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
            --namespace ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--registry icr.io --inputDir ${OFFLINEDIR_CPFS} --recursive"

        # Verify that ibm-cpd-scheduling-catalog is READY
        oc get catalogsource -n ${PROJECT_CATSRC} ibm-cpd-scheduling-catalog \
            -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
    - Create the scheduling service catalog source **(ibm-cpd-scheduling)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cpd-scheduling-1.3.4.tgz \
            --inventory schedulerSetup \
            --namespace ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--inputDir ${OFFLINEDIR_CPD} --recursive"

        # Verify that ibm-cpd-scheduling-catalog is READY
        oc get catalogsource -n ${PROJECT_CATSRC} ibm-cpd-scheduling-catalog \
            -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
    - Create the IBM Cloud Pak for Data catalog source **(ibm-cp-datacore)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
            --inventory cpdPlatformOperator \
            --namespace ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--inputDir ${OFFLINEDIR_CPD} --recursive"

        # Verify that cpd-platform is READY
        oc get catalogsource -n ${PROJECT_CATSRC} cpd-platform \
            -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
    - (略) Create the Db2U catalog source if you plan to upgrade or install one of the following services
    - Create the Watson Knowledge Catalog catalog source **(ibm-wkc)**
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-wkc-4.0.8.tgz \
            --inventory wkcOperatorSetup \
            --namespace ${PROJECT_CATSRC} \
            --action install-catalog \
            --args "--inputDir ${OFFLINEDIR_CPD} --recursive"

        # Verify that ibm-cpd-wkc-operator-catalog is READY
        oc get catalogsource -n ${PROJECT_CATSRC} ibm-cpd-wkc-operator-catalog \
            -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
        ```
## [Installing or upgrading IBM Cloud Pak foundational services](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=upgrade-installing-upgrading-cloud-pak-foundational-services)
- Environment variable
    ```bash
    export PROJECT_CPFS_OPS=ibm-common-services
    export PROJECT_CATSRC=openshift-marketplace
    ```
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

[Back to top](#)
# Watson Knowledge Catalog (wkc)