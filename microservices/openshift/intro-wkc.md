# Watson Knowledge Catalog (WKC)
## 產品特色
透過可在任何雲端上執行的開放式可延伸資料與 AI 平台，來加速您邁向 AI 的旅程，藉此改變您的業務運作方式。

IBM Cloud Pak for Data 是一種完全整合的資料與 AI 平台，它將企業收集、組織與分析資料的方式現代化，以便為整個組織注入 AI。此重視雲端設計的平台，可在整個分析生命週期中統合領先市場的服務。從資料管理、DataOps、控管、商業分析到自動化 AI，IBM Cloud Pak for Data 可協助消除成本高昂且往往互相競爭的單點解決方案需求，同時提供您需要的資訊架構以便順利實作 AI。

以 Red Hat OpenShift 精簡混合雲做為建置基礎的 IBM Cloud Pak for Data，它充分利用基礎資源以及基礎架構優化與管理。此解決方案完全支援多雲端環境，例如 Amazon Web Services (AWS)、Azure、Google Cloud、IBM Cloud 及私有雲部署。

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