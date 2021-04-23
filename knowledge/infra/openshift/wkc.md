# Watson Knowledge Catalog (WKC)
## 產品特色
透過可在任何雲端上執行的開放式可延伸資料與 AI 平台，來加速您邁向 AI 的旅程，藉此改變您的業務運作方式。

IBM Cloud Pak® for Data 是一種完全整合的資料與 AI 平台，它將企業收集、組織與分析資料的方式現代化，以便為整個組織注入 AI。此重視雲端設計的平台，可在整個分析生命週期中統合領先市場的服務。從資料管理、DataOps、控管、商業分析到自動化 AI，IBM Cloud Pak for Data 可協助消除成本高昂且往往互相競爭的單點解決方案需求，同時提供您需要的資訊架構以便順利實作 AI。

以 Red Hat® OpenShift® 精簡混合雲做為建置基礎的 IBM Cloud Pak for Data，它充分利用基礎資源以及基礎架構優化與管理。此解決方案完全支援多雲端環境，例如 Amazon Web Services (AWS)、Azure、Google Cloud、IBM Cloud® 及私有雲部署。

<br><img src="https://www.ibm.com/support/knowledgecenter/SSQNUZ_latest/cpd/plan/images/cluster-arch.png" width="500">

## Relationship with Azure
**IBM Cloud Pak for Data** is an analytics platform that helps you prepare your data for AI. It enables data engineers, data steward (管家), data scientists, and business analysts to collaborate using an integrated multiple-cloud platform.
Cloud Pak for Data uses IBM’s deep analytics portfolio to help organizations meet data and analytics challenges.
The required building blocks (collect, organize, analyze, infuse) for information architecture are available using Cloud Pak for Data on Azure.
Key Features:
- Connect ALL data and eliminate data silos for self service analytics
- Automate and govern a unified data & AI lifecycle
- Analyze your data in smarter ways, with ML and Deep Learning capabilities
- Operationalize AI with trust and transparency
This template deploys IBM Cloud Pak for Data v3.5.0 on Openshift Container Platform 4.5. It creates Azure services and features, including VNets, Availability Zones, Availability Sets, security groups, Managed Disks, and Azure Load Balancers to build a reliable and scalable cloud platform.

Cloud Pak for Data offers a try and buy experience. When you buy Cloud Pak for Data you will automatically OpenShift entitlements to run your workloads. Cloud Pak for Data offers a 60-day trial and beyond (超過) the 60-day period, you will need to purchase the Cloud Pak for Data by following the instructions in the 'Purchase' section below.

Deploying this template:
Requirements:
- Azure App Service Domain
- Azure Service Principal with Contributor and User Access Administrator roles.
- RedHat OpenShift Pull Secret
- Cloud Pak for Data v3.5.0 API Key

## 指令
```bash
cd ~
mkdir ocp4.5_inst
cd ocp4.5_inst
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-install-linux-4.5.36.tar.gz
tar xvf openshift-install-linux-4.5.36.tar.gz
./openshift-install create install-config --dir=/home/cpdadmin/ocp4.5_cust
# ? azure subscription id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
# ? azure tenant id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
# ? azure service principal client id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
# ? azure service principal client secret [? for help] **********************************
./openshift-install --dir=/home/cpdadmin/ocp4.5_cust create cluster --log-level=info
./openshift-install --dir=/home/cpdadmin/ocp4.5_cust create cluster --log-level=debug
./openshift-install --dir=/home/cpdadmin/ocp4.5_cust wait-for bootstrap-complete --log-level=info
# INFO Credentials loaded from file “/home/cpdadmin/.azure/osServicePrincipal.json”
# INFO Consuming Install Config from target directory
# INFO Creating infrastructure resources…
```
- https://console-openshift-console.apps.wkc.corpnet.auo.com/k8s/ns/zen/pods
- https://zen-cpd-zen.apps.wkc.corpnet.auo.com/ibm/iis/igcui/connections/autoDiscoveryResults

## Proxy
Production environments can **deny direct access to the Internet** and instead have an HTTP or HTTPS proxy available. You can configure OpenShift Container Platform to use a proxy by **modifying the Proxy object for existing clusters** or by configuring the proxy settings in the install-config.yaml file for new clusters.
> The cluster-wide proxy is only supported if you used a user-provisioned infrastructure installation or provide your own networking, such as a VPC or **VNet**, for a supported provider.

### Enabling the Cluster-Wide Proxy
The Proxy object is used to manage the cluster-wide egress proxy. When a cluster is installed or upgraded without the proxy configured, a Proxy object is still generated but it will have a nil spec. For example:
```yaml
apiVersion: config.openshift.io/v1
kind: Proxy
metadata:
  name: cluster
spec:
  trustedCA:
    name: ""
status:
```
- Prerequisites
- Procedure
    1. Create a ConfigMap that contains any additional CA certificates required for proxying HTTPS connections.
    2. Use the `oc edit` command to modify the Proxy object:
        ```bash
        oc edit proxy/cluster
        ```
    3. Configure the necessary fields for the proxy:
        ```yaml
        apiVersion: config.openshift.io/v1
        kind: Proxy
        metadata:
            name: cluster
        spec:
            httpProxy: http://10.250.12.5:3128
            httpsProxy: http://10.250.12.5:3128
            noProxy: example.com
            readinessEndpoints:
            - http://www.google.com
            - https://www.google.com
            trustedCA:
                name: user-ca-bundle
        ```
    4. Save the file to apply the changes.

## 參考
- [因應多雲資料處理分析需求，IBM提供專屬預先整合套件](https://www.ithome.com.tw/review/134115)
- [IBM Cloud Pak for Data on the AWS Cloud Quick Start Reference Deployment](https://aws-quickstart.github.io/quickstart-ibm-icp-for-data/)
- [Architecture for IBM Cloud Pak for Data](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_latest/cpd/plan/architecture.html)
    - [Cloud deployment environments](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_latest/cpd/plan/deployment-environments.html)
    - [Storage considerations](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_latest/cpd/plan/storage_considerations.html)
- [Red Hat OpenShift Container Platform 容器應用平台](https://www.sysage.com.tw/Solution/Detail?solutionid=114)
- [Cloud Pak for Data 3.5 on OCP 4.5 on Azure](https://github.com/IBM/cp4d-deployment/blob/master/selfmanaged-openshift/azure/README.md#deployment-topology)
- [在 Microsoft Azure 上使用 Terraform 安装 Cloud Pak for Data](https://www.ibm.com/support/knowledgecenter/zh/SSQNUZ_2.1.0/com.ibm.icpdata.doc/zen/install/terraformazure.html?view=embed)
- [Installing on Azure](https://docs.openshift.com/container-platform/4.5/installing/installing_azure)