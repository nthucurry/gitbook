# Watson Knowledge Catalog (WKC)
## 產品特色
透過可在任何雲端上執行的開放式可延伸資料與 AI 平台，來加速您邁向 AI 的旅程，藉此改變您的業務運作方式

IBM Cloud Pak® for Data 是一種完全整合的資料與 AI 平台，它將企業收集、組織與分析資料的方式現代化，以便為整個組織注入 AI。此重視雲端設計的平台，可在整個分析生命週期中統合領先市場的服務。從資料管理、DataOps、控管、商業分析到自動化 AI，IBM Cloud Pak for Data 可協助消除成本高昂且往往互相競爭的單點解決方案需求，同時提供您需要的資訊架構以便順利實作 AI。

以 Red Hat® OpenShift® 精簡混合雲做為建置基礎的 IBM Cloud Pak for Data，它充分利用基礎資源以及基礎架構優化與管理。此解決方案完全支援多雲端環境，例如 Amazon Web Services (AWS)、Azure、Google Cloud、IBM Cloud® 及私有雲部署。瞭解 IBM Cloud Pak for Data 如何能降低您的總擁有成本並加速創新。

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

## Issue
```txt
CR:
建置 WKC 專案，預計會於 Azure 新建以下資源:
1. Resource Group: WKC
2. 8 台 RedHat VM (bastion*1, master*3, worker*4), 1 台 CentOS/Ubuntu VM (NFS Server)
3. Azure NSG:
    InBound, OutBound: 22, 80, 443, 6443, 22623
4. Azure subnet:
    IP: 10.250.101.0/26 (master subnet), 10.250.101.64/26 (worker subnet)
    以上 subnet 需開通以下連線:
    (1) internet 連線, by azure proxy (VM)
        - 建置時開放對外連線以下載安裝程式 (80, 443)
        - 建置完畢後，對外連線僅開放必要 Repo (如 quay.io) 更新 packages
    (2) intranet 連線
        a. 開放 80, 443, 6443 ports for 新竹 OA 網段
        b. 開放 22 port for 新竹跳板機
        c. 開放新竹 server farm 網段的 1433, 1521-1530 ports
5. DNS Forwarder:
    將 domain name = azure.corpnet.auo.com 導到 Azure DNS Forwarder VM (10.248.15.4, 10.248.15.5)
Attach: 架構圖
```

## Firewall Activation
- Azure
    - VNet: /24 即可
        - wkc-bootnode-subnet: 10.30.124.0/27
        - wkc-master-subnet: 10.30.124.64/26
        - wkc-worker-subnet: 10.30.124.128/26
    - NSG
        - WKC-MASTER-NSG: 80, 443, 6443, 22623
        - WKC-WORK-NSG: 6443, 22623
    <br><ing src="https://github.com/IBM/cp4d-deployment/blob/master/selfmanaged-openshift/azure/images/AzureCPD-Arch.png">
- Azure to On-Premises
- Securing communication ports
    - Cluster ports
    - Ports for services
- storage
    <br><img src="https://docs.microsoft.com/en-us/azure/virtual-network/media/network-isolation/service-tags.png">

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