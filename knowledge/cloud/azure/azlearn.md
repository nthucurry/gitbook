# Azure Learn Lesson
- https://github.com/MicrosoftLearning
    - 104
        - https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/
        - https://github.com/MicrosoftLearning/Lab-Demo-Recordings/blob/master/AZ-104.md

## EDA POC
- 如何跨 subscription migration
- 權限
    - NSG 設定權責?
    - 控制 subscription 最高權限 -- Daivd
- policy
    - assign policy
        - Not allowed resource types
            1. microsoft.network/virtualnetworks
            3. microsoft.network/virtualnetworks/virtualnetworkpeerings
            2. microsoft.network/networksecuritygroups
        - Allowed locations
            1. southeastasia
        - 注意 policy 連最高的 owner 都會被管理到，所以需要視情況放行(enable -> disable)，完事後再啟動 policy
- IAM
    - 用這個來控制 end-user 權限
    - deny 讀寫，read 視情況
        - Microsoft.Authorization
        - Microsoft.Network/networkSecurityGroups
        - Microsoft.Network/azurefirewalls
        - Microsoft.Network/applicationGateways
        ```json
        "permissions": [
            {
                "actions": [
                    "*"
                ],
                "notActions": [
                    "Microsoft.Authorization/elevateAccess/action",
                    "Microsoft.Authorization/classicAdministrators/write",
                    "Microsoft.Authorization/classicAdministrators/delete",
                    "Microsoft.Authorization/classicAdministrators/operationstatuses/read",
                    "Microsoft.Authorization/denyAssignments/write",
                    "Microsoft.Authorization/denyAssignments/delete",
                    "Microsoft.Authorization/policyAssignments/write",
                    "Microsoft.Authorization/policyAssignments/delete",
                    "Microsoft.Authorization/policyAssignments/exempt/action",
                    "Microsoft.Authorization/policyAssignments/privateLinkAssociations/write",
                    "Microsoft.Authorization/policyAssignments/privateLinkAssociations/delete",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/write",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/delete",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnections/write",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnections/delete",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/write",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/delete",
                    "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/validate/action",
                    "Microsoft.Authorization/policyDefinitions/write",
                    "Microsoft.Authorization/policyDefinitions/delete",
                    "Microsoft.Authorization/policies/audit/action",
                    "Microsoft.Authorization/policies/auditIfNotExists/action",
                    "Microsoft.Authorization/policies/deny/action",
                    "Microsoft.Authorization/policies/deployIfNotExists/action",
                    "Microsoft.Authorization/policyExemptions/write",
                    "Microsoft.Authorization/policyExemptions/delete",
                    "Microsoft.Authorization/policySetDefinitions/write",
                    "Microsoft.Authorization/policySetDefinitions/delete",
                    "Microsoft.Authorization/roleAssignments/write",
                    "Microsoft.Authorization/roleAssignments/delete",
                    "Microsoft.Authorization/roleDefinitions/write",
                    "Microsoft.Authorization/roleDefinitions/delete",
                    "Microsoft.Network/networkSecurityGroups/write",
                    "Microsoft.Network/networkSecurityGroups/delete",
                    "Microsoft.Network/networkSecurityGroups/securityRules/write",
                    "Microsoft.Network/networkSecurityGroups/securityRules/delete"
                ],
                "dataActions": [],
                "notDataActions": []
            }
        ]
        ```
- 不同 vNet 可以跨 subscription 互相連線
    - network peering: 跨 vNet 設定後可以連
    - peering
- SOP
    1. 建立 resource group
    2. 建立 policy
    3. 建立 NSG

## 1. Identity
### Azure Active Directory (建帳號)
AAD is Microsoft’s multi-tenant cloud-based directory and identity management service. For IT Admins, AAD provides an affordable (可負擔的), easy to use solution to give employees and business partners single sign-on (SSO) access to thousands of cloud SaaS Applications like Microsoft 365, Salesforce, DropBox, and Concur.
<br><img src="https://www.synacktiv.com/sites/default/files/inline-images/app-management-overview.png">
<br><img src="https://strongsecurity.co.za/wp-content/uploads/2020/04/Diagram-Azure-AD-for-Apps-1.png">

### Azure AD Join
AAD enables SSO to devices, apps, and services from anywhere. The proliferation (增殖) of devices - including Bring Your Own Device (BYOD) – empowers end users to be productive wherever and whenever. But, IT administrators must ensure corporate assets (資產) are protected and that devices meet standards for security and compliance (合規).
<br><img src="https://docs.microsoft.com/zh-tw/azure/active-directory/devices/media/concept-azure-ad-join/azure-ad-joined-device.png">

### Bulk User Accounts
- use PowerShell
- import CSV file

## 2. Governance And Compliance (治理與合規)
### Azure Subscriptions
<img src="https://cloudinfrastructureservices.co.uk/wp-content/uploads/2018/06/Multi-Subscription-Model.png">
- subscription usage
    - free
    - pay-as-you-go
    - enterprise agreement
    - Student
- cost savings
    - reservations (保留)
        <br>It helps you save money by pre-paying for one-year or three-years of Azure resources.
    - azure hybrid benefits (自帶授權)
        <br>It is a pricing benefit for customers who have licenses with Software Assurance, which helps maximize the value of existing on-premises Windows Server and/or SQL Server license investments when migrating to Azure.
    - azure credits
    - azure regions (區域)
    - budgets (預算)

### Management Groups
If your organization has several subscriptions, you may need a way to efficiently manage access, policies, and compliance for those subscriptions. Azure management groups provide a level of scope above subscriptions. You organize subscriptions into containers called management groups and apply your governance conditions to the management groups.

### Azure Policy
Azure Policy is a service in Azure that you use to create, assign and manage policies. These policies enforce different rules over your resources, so those resources stay compliant with (符合) your corporate standards and service level agreements. Azure Policy does this by running evaluations of your resources and scanning for those not compliant with the policies you have created.
- 連 owner 都會被管道，只要有在 AAD 內都會被管道
- https://github.com/Azure/azure-policy
- NSG, subscription, resource group
- resource types: 僅能建立特定 IaaS, PaaS, SaaS
    <br><img src="../../../img/cloud/azure/iam-network-sample.png" width=700>
- VM SKUs: 指定規格
- location
- tag
    - 必使用 tag 才能建立資源
        - service type: DB, AP...
    - 繼承 tag
- backup policy

### Role-Based Access Control (RBAC, IAM)
RBAC helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to.
- 委派三元素: 範圍、角色、誰
- 產出 json file
    ```powershell
    Get-AzRoleDefinition -name reader | convertto-json
    ```
### Group
- dynamic group: 可依據條件來設定群組，例如 job title = XXX
- 在同一個 AAD 下，可跨 subscription 做管理

### Tag
- 管理不同 location、不同 resource group 的資源
    - IaaS: VM
    - PaaS: SQL database
- 同個 resource group，下 tag 沒辦法帶到子目錄去，除非
    - 寫程式
    - azure policy

## Resource
- 同個 AAD 之下， resource 可跨 subscription or other resource group 移動
- 跨 subscription 移動時，要注意目的端有沒有相對應的 resource type register

## Template
https://github.com/Azure/azure-quickstart-templates

## Migrate to another subscription
<img src="../../../img/cloud/azure/migratie-to-new-subscription.png" width=700><br>
https://medium.com/@calloncampbell/moving-your-azure-resources-to-another-subscription-or-resource-group-1644f43d2e07


## 4. Virtual Networking
## Public IP
- basic vs standard
    - basic
        - 動態、靜態 IP
        - 預設無安全政策
    - standard
        - 靜態
        - 預設需有 NSG
        - 支援高可用性

## NSG
- azure firewall 要錢
- 要 same region 才有作用

## Private DNS Zone

## vNet Peering
Perhaps the simplest and quickest way to connect your VNets is to use VNet peering. Virtual network peering enables you to seamlessly (無縫地) connect two Azure virtual networks. Once peered, the virtual networks appear as one, for connectivity purposes.
<br><img src='../../../img/cloud/azure/vnet-peering.png'>
<br><img src="https://miro.medium.com/max/505/1*3tQlWO0d82Vt6oO0G7jbmA.png">
- 軟體定義網路
- 可跨 region, subscription and tenant
- 資料流出 data center 才要費用

## VPN Gateway
A VPN gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. You can also use a VPN gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. Each virtual network can have only one VPN gateway. However, you can create multiple connections to the same VPN gateway. When you create multiple connections to the same VPN gateway, all VPN tunnels share the available gateway bandwidth.
<br><img src='https://docs.microsoft.com/zh-tw/azure/vpn-gateway/media/tutorial-site-to-site-portal/diagram.png'>
- 要建立 route table
- 當要使用 S2S VPN 時，與地端連
- 預設都用 route-based

## ExpressRoute
Azure ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a dedicated private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure, Microsoft 365, and CRM Online.
<br><img src='https://docs.microsoft.com/zh-tw/azure/expressroute/media/expressroute-introduction/expressroute-connection-overview.png'>
<br><img src="https://i.pinimg.com/originals/26/79/a3/2679a35f8b6838776609b0563eb7b85c.png">

## Route Table
- 需同 region 才可適用

## Service Endpoint
- 針對 PaaS 服務建立連線，不需走 VPN gateway

## Private Link (Private Endpoint)

## Azure Load Balancer (Lev 4)
<img src="https://docs.microsoft.com/zh-tw/azure/load-balancer/media/load-balancer-distribution-mode/load-balancer-distribution.png">

## Session Persistence

## Application Gateway (Lev 7)
Application Gateway manages the requests that client applications can send to a web app. Application Gateway routes traffic to a pool of web servers based on the URL of a request. This is known as application layer routing. The pool of web servers can be Azure virtual machines, Azure virtual machine scale sets, Azure App Service, and even on-premises servers.
<br><img src="https://docs.microsoft.com/zh-tw/azure/application-gateway/media/overview/figure1-720.png">
<br><img src="https://docs.microsoft.com/zh-tw/azure/application-gateway/media/application-gateway-components/application-gateway-components.png">
<br><img src="https://miro.medium.com/max/1400/0*X38oEgWmuKHRAqVP.png">

## 7. Azure Storage
### Azure Storage Services
- Azure Containers (Blobs): A massively scalable object store for text and binary data.
- Azure Files: Managed file shares for cloud or on-premises deployments.
- Azure Queues: A messaging store for reliable messaging between application components.
- Azure Tables: A NoSQL store for schemaless storage of structured data.

### Blob Storage
A service that stores **unstructured data** in the cloud as objects/blobs. Blob storage can store any type of text or binary data, such as a document, media file, or application installer. Blob storage is also referred to as object storage.
<br><img src="https://docs.microsoft.com/zh-tw/azure/storage/blobs/media/storage-quickstart-blobs-dotnet/blob1.png">
- blob access tiers
    - hot(online)
    - cool(online)
    - archive(offline, 先解凍再讀取)
- 可以建立 rule by lifecycle，去控管檔案的儲存方式
- 可覆寫 container 內容
- files vs blobs

### File Sync

## 8. Azure Virtual Machine
- data disk 可以<font color=#FF0000>熱插拔</font>

### Virtual Machine Storage
- unmanaged disks
- managed disks (推薦)

### Virtual Machine Connections
<img src="https://petri.com/wp-content/uploads/sites/3/2020/06/Figure1-4.png">

### Availability Sets
A logical feature used to ensure that a group of related VMs are deployed so that they aren't all subject to a single point of failure and not all upgraded at the same time during a host operating system upgrade in the datacenter. 言下之意是把 VM 放在多個的機櫃上面
- update domain: VM
    - an upgrade domain (UD) is a group of nodes that are upgraded together during the process of a service upgrade (rollout).
- fault domain: 機櫃
    - a fault domain (FD) is a group of nodes that represent a physical unit of failure. A fault domain defines a group of virtual machines that share a common set of hardware, switches, that share a single point of failure.
<img src="../../../img/cloud/azure/availability-set.jpg">

### Availability Zones (相同 region，不同 data center)
A HA offering that protects your applications and data from datacenter failures.
- each zone is made up of one or more datacenters equipped.
- to ensure resiliency, there’s a minimum of three separate zones in all enabled regions.
<img src="https://mwesterink.files.wordpress.com/2018/09/azure-az-2.png">

### Scaling Concepts
- vertical scaling (scale up and scale down): 須重開機才會生效
- horizontal scaling (scale out and scale in)
- scale sets
    - all VM instances are created from the same base OS image and configuration.
    - 是以 VM 為單位來增加/減少資源
- autoscale
    <img src="https://docs.microsoft.com/zh-tw/azure/azure-monitor/platform/media/autoscale-overview/autoscale_overview_v4.png">

### Virtual Machine Extensions
Azure virtual machine extensions are small applications that provide post-deployment configuration and automation tasks on Azure VMs. For example, if a virtual machine requires software installation, anti-virus protection, or a configuration script inside, a VM extension can be used. Extensions are all about managing your virtual machines.

## 9. Serverless Computing (無伺服器運算)
### App Service Overview
- 不能換 region

### Backup an App Service
備份到 storage account 轉為 blob，此時可以換 region

### Container Service
- containers vs virtual machines

## 10. Data Protection
### Azure Backup
Azure Backup is the Azure-based service you can use to back up (or protect) and restore your data in the Microsoft cloud. Azure Backup replaces your existing on-premises or off-site backup solution with a cloud-based solution that is reliable, secure, and cost-competitive.

### Virtual Machine Data Protection
- azure backup
- azure site recovery
    - 用 recover service 備份 azure resource 時，必須為同 region
- managed disk snapshots

## 11. Monitoring