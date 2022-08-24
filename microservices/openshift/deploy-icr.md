# [Mirroring images to your private container registry](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=tasks-mirroring-images-your-private-container-registry)
- Installing the software needed to mirror images
    - OpenShift CLI (本來就會有)
    - IBM Cloud Pak CLI (cloudctl)
    - httpd-tools
        - `yum install httpd-tools`
    - skopeo (可以從 OpenShift OS 拿)
- [Setting up your environment to download CASE packages](https://www.ibm.com/docs/en/SSQNUZ_4.0/cpd/install/install-variables.html)
    - `source cpd_vars.sh`
- Initialize the intermediary container registry (ICR)
    ```bash
    cloudctl case launch \
        --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
        --inventory cpdPlatformOperator \
        --action init-registry \
        --args "--registry ${INTERMEDIARY_REGISTRY_HOST} --user ${INTERMEDIARY_REGISTRY_USER} --pass ${INTERMEDIARY_REGISTRY_PASSWORD} --dir ${OFFLINEDIR_CPD}/imageregistry"
    ```
- Start the ICR
    ```bash
    cloudctl case launch \
        --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
        --inventory cpdPlatformOperator \
        --action start-registry \
        --args "--port ${INTERMEDIARY_REGISTRY_PORT} --dir ${OFFLINEDIR_CPD}/imageregistry --image docker.io/library/registry:2"
    ```
- Downloading shared cluster component CASE packages
    ```bash
    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-cp-common-services \
        --version 1.14.0 \
        --outputdir ${OFFLINEDIR_CPFS}
    ```
- Downloading service CASE packages (WKC)
    ```bash
    cloudctl case save \
        --repo ${PATH_CASE_REPO} \
        --case ibm-wkc \
        --version 4.0.9 \
        --outputdir ${OFFLINEDIR_CPD}
    ```
- Mirror all of the images
    - from the OFFLINEDIR directory to ICR (Cloud Pak for Data platform CASE package)
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
            --inventory cpdPlatformOperator \
            --action mirror-images \
            --args "--registry ${INTERMEDIARY_REGISTRY_LOCATION} --inputDir ${OFFLINEDIR_CPD}"
        ```
    - from the OFFLINEDIR_CPFS directory to ICR (IBM Cloud Pak foundational services CASE package)
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPFS}/ibm-cp-common-services-1.14.0.tgz \
            --inventory ibmCommonServiceOperatorSetup \
            --action mirror-images \
            --args "--registry ${INTERMEDIARY_REGISTRY_LOCATION} --inputDir ${OFFLINEDIR_CPFS}"
        ```
- Mirroring images to the private container registry
    - Store the ICR credentials
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
            --inventory cpdPlatformOperator \
            --action configure-creds-airgap \
            --args "--registry ${INTERMEDIARY_REGISTRY_LOCATION} --user ${INTERMEDIARY_REGISTRY_USER} --pass ${INTERMEDIARY_REGISTRY_PASSWORD}"
        ```
    - Store the private container registry credentials
        ```bash
        cloudctl case launch \
            --case ${OFFLINEDIR_CPD}/ibm-cp-datacore-2.0.13+05022022.tgz \
            --inventory cpdPlatformOperator \
            --action mirror-images \
            --args "--registry ${PRIVATE_REGISTRY_LOCATION} --user ${PRIVATE_REGISTRY_PUSH_USER} --pass ${PRIVATE_REGISTRY_PUSH_PASSWORD} --inputDir ${OFFLINEDIR_CPD}"
        ```
- Mirror the images to the private container registry (IBM Cloud Pak foundational services CASE package)
    ```bash
    cloudctl case launch \
        --case ${OFFLINEDIR_CPFS}/ibm-cp-common-services-1.14.0.tgz \
        --inventory ibmCommonServiceOperatorSetup \
        --action mirror-images \
        --args "--registry ${PRIVATE_REGISTRY_LOCATION} --user ${PRIVATE_REGISTRY_PUSH_USER} --pass ${PRIVATE_REGISTRY_PUSH_PASSWORD} --inputDir ${OFFLINEDIR_CPFS}"
    ```