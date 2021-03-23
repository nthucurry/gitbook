# Watson Knowledge Catalog (WKC)
## 目的
資料治理平台 - IBM Cloud Pack for Data 評估與導入

## 產品特色
透過可在任何雲端上執行的開放式可延伸資料與 AI 平台，來加速您邁向 AI 的旅程，藉此改變您的業務運作方式

IBM Cloud Pak® for Data 是一種完全整合的資料與 AI 平台，它將企業收集、組織與分析資料的方式現代化，以便為整個組織注入 AI。此重視雲端設計的平台，可在整個分析生命週期中統合領先市場的服務。從資料管理、DataOps、控管、商業分析到自動化 AI，IBM Cloud Pak for Data 可協助消除成本高昂且往往互相競爭的單點解決方案需求，同時提供您需要的資訊架構以便順利實作 AI。

以 Red Hat® OpenShift® 精簡混合雲做為建置基礎的 IBM Cloud Pak for Data，它充分利用基礎資源以及基礎架構優化與管理。此解決方案完全支援多雲端環境，例如 Amazon Web Services (AWS)、Azure、Google Cloud、IBM Cloud® 及私有雲部署。瞭解 IBM Cloud Pak for Data 如何能降低您的總擁有成本並加速創新。

## Cluster Architecture
- multi-node cluster
- load balancer = three master + infra nodes
- minimum recommended
<br><img src="https://www.ibm.com/support/knowledgecenter/SSQNUZ_latest/cpd/plan/images/cluster-arch.png">

## Storage Architecture
It supports NFS, Portworx, Red Hat OpenShift Container Storage, and IBM Cloud File Storage. Your cluster can contain a mix of storage types. However, each service can target **only one type** of storage.
| Type                 | OpenShift Container Storage | NFS             | Portworx   | IBM Cloud File Storage |
|----------------------|-----------------------------|-----------------|------------|------------------------|
| Backup and Restore   | snapshots and clones        | limited support |            |                        |
| HA                   |                             |                 |            |                        |
| License              | yes                         | no              | it depends |                        |
| Network Requirements | 10 Gbps                     |                 |            |                        |


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
- [3/25]
    1. 建立 azure domain name
    2. 建立 resource-group
    3. ~~建立 vnet wkc-vnet~~
    4. 建立 vnet subnet
    5. 建立 network security group (WKC-MASTER-NSG / WKC-WORK-NSG)
            - 在 WKC-MASTER-NSG 加上 80, 443, 6443, 22623
            - 在 WKC-WORK-NSG 加上  6443, 22623
    6. ~~雲對地 VPN 網路設定~~
    7. ~~地端對 WKC DNS 設定~~
    8. vnet 中各 Node 需能存取 Internet 連線
- [3/17] 討論的問題點為：
    1. 安裝是由 IBM 於雲端安裝完成嗎? AUO 只需要維運即可? 或還需要作業那些內容?
    2. IBM 提到使用代理商跟我們合作軟體服務，AUO先前是跟恆鼎代理商合作，但因為合作狀況不是很好，有更佳推薦代理商嗎?
    3. 合約的部份可以增加下圖一第七點異常與備援機制(或原本已含)?
    4. 目前有其他導入 WKC 並連線至阿里雲的經驗嗎? 可提供 AUO 參考與建議嗎?
    <br><img src="../../img/wkc/wkc-list.gif">

## Firewall Activation
- Azure
    - VNet: /24 即可
        - wkc-bootnode-subnet: 10.30.124.0/27
        - wkc-master-subnet: 10.30.124.64/26
        - wkc-worker-subnet: 10.30.124.128/26
    - NSG
        - WKC-MASTER-NSG: 80, 443, 6443, 22623
        - WKC-WORK-NSG: 6443, 22623
- Azure to On-Premises
- Securing communication ports
    - Cluster ports
    - Ports for services

## 參考
- [因應多雲資料處理分析需求，IBM提供專屬預先整合套件](https://www.ithome.com.tw/review/134115)
- [IBM Cloud Pak for Data on the AWS Cloud Quick Start Reference Deployment](https://aws-quickstart.github.io/quickstart-ibm-icp-for-data/)
- [Architecture for IBM Cloud Pak for Data](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_latest/cpd/plan/architecture.html)
    - [Cloud deployment environments](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_latest/cpd/plan/deployment-environments.html)
    - [Storage considerations](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_latest/cpd/plan/storage_considerations.html)
- [Red Hat OpenShift Container Platform 容器應用平台](https://www.sysage.com.tw/Solution/Detail?solutionid=114)
- [Cloud Pak for Data 3.5 on OCP 4.5 on Azure](https://github.com/IBM/cp4d-deployment/blob/master/selfmanaged-openshift/azure/README.md#deployment-topology)
- [在 Microsoft Azure 上使用 Terraform 安装 Cloud Pak for Data](https://www.ibm.com/support/knowledgecenter/zh/SSQNUZ_2.1.0/com.ibm.icpdata.doc/zen/install/terraformazure.html?view=embed)