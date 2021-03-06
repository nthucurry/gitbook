# Azure Learn Lesson
- https://github.com/MicrosoftLearning
    - 104
        - https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/
        - https://github.com/MicrosoftLearning/Lab-Demo-Recordings/blob/master/AZ-104.md
- https://imgur.com/ZQKMS42
- https://imgur.com/6X9Jv5b
- https://imgur.com/XNIgTLF
- https://imgur.com/s5qVWRt
- https://imgur.com/GPkmUUN
- https://imgur.com/crQDULD
- https://imgur.com/gsa8Cij
- https://imgur.com/wCtaGzM

## 1. Identity
### Azure Active Directory (建帳號)
AAD is Microsoft’s multi-tenant cloud-based directory and identity management service. For IT Admins, AAD provides an affordable (可負擔的), easy to use solution to give employees and business partners single sign-on (SSO) access to thousands of cloud SaaS Applications like Microsoft 365, Salesforce, DropBox, and Concur.
<br><img src="https://www.synacktiv.com/sites/default/files/inline-images/app-management-overview.png" boarder='1'>
<br><img src="https://strongsecurity.co.za/wp-content/uploads/2020/04/Diagram-Azure-AD-for-Apps-1.png">

### Azure AD Join
AAD enables SSO to devices, apps, and services from anywhere. The proliferation (增殖) of devices - including Bring Your Own Device (BYOD) – empowers end users to be productive wherever and whenever. But, IT administrators must ensure corporate assets (資產) are protected and that devices meet standards for security and compliance (合規).
<br><img src="https://docs.microsoft.com/zh-tw/azure/active-directory/devices/media/concept-azure-ad-join/azure-ad-joined-device.png">

### Bulk User Accounts
- use PowerShell
- import CSV file

## 2. Governance And Compliance (治理與合規)
### Azure Subscriptions
<img src="https://cloudinfrastructureservices.co.uk/wp-content/uploads/2018/06/Multi-Subscription-Model.png"><br>
- subscription usage
    - free
    - pay-as-you-go
    - enterprise agreement
    - student
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
<br><img src="https://docs.microsoft.com/zh-tw/azure/governance/management-groups/media/tree.png">

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

### Azure RBAC Roles vs Azure AD Roles
| Azure RBAC roles                                                            | Azure AD roles                  |
|-----------------------------------------------------------------------------|---------------------------------|
| Manage access to Azure resources.                                           | Manage access to AAD resources. |
| Scope can be specified at multiple levels (MG, subscription, RG, resource). | Scope is at the tenant level.   |

### RBAC Authentication
<img src="https://docs.microsoft.com/en-us/azure/role-based-access-control/media/rbac-and-directory-admin-roles/rbac-admin-roles.png">

## 3. Azure Administration
### Resource Manager
Azure Resource Manager enables you to work with the resources in your solution as a group. You can deploy, update, or delete all the resources for your solution in a single, coordinated operation.

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

## Moving Resources
<img src="../../../img/cloud/azure/migratie-to-new-subscription.png" width=700><br>
https://medium.com/@calloncampbell/moving-your-azure-resources-to-another-subscription-or-resource-group-1644f43d2e07

## 4. Virtual Networking
### Public IP
- basic vs standard
    - basic
        - 動態、靜態 IP
        - 預設無安全政策
    - standard
        - 靜態
        - 預設需有 NSG
        - 支援高可用性
        - public load balancer

### Network Security Groups (NSG)
NSG contains a list of security rules that allow or deny inbound or outbound network traffic. NSG can be associated to a subnet or a network interface. NSG can be associated multiple times.
<br><img src="https://docs.microsoft.com/zh-tw/azure/virtual-network/media/network-security-group-how-it-works/network-security-group-interaction.png">
- VM4: Traffic is allowed to VM4, because a network security group isn't associated to Subnet3, or the network interface in the virtual machine. All network traffic is allowed through a subnet and network interface if they don't have a network security group associated to them.

### Azure Firewall
You can centrally create, enforce, and log application and network connectivity policies across subscriptions and virtual networks.
<br><img src="https://docs.microsoft.com/zh-tw/azure/firewall/media/overview/firewall-threat.png">
- AzureFirewallSubnet - the firewall is in this subnet.
- Workload-SN - the workload server is in this subnet. This subnet's network traffic goes through the firewall.
<br><img src="https://docs.microsoft.com/zh-tw/azure/firewall/media/tutorial-firewall-deploy-portal/tutorial-network.png">
- features
    - built-in high availability
    - availability zones
    - unrestricted cloud scalability.
    - application FQDN filtering rules
- application rules
    <br>define fully qualified domain names (FQDNs) that can be accessed from a subnet (內網能夠存取的外部網址)
- network rules
    <br>define source address, protocol, destination port, and destination address (通常用在設定 DNS)
- [subnet size: /26](https://docs.microsoft.com/zh-tw/azure/firewall/firewall-faq#why-does-azure-firewall-need-a--26-subnet-size)
- 步驟
    1. NSG 設定阻擋 VNet 往外部的連線，內部互聯則開通
    2. 建立 firewall
        - 設定 application rule collection 指定 FQDNs 可存取
        - 設定指定的 DNS 可解析 FQDNs
    3. 建立 route table
        - 將目標 subnet 放於內
        - 將 0.0.0.0/0 都需經過 firewall (IP binding)

### DNS Record Sets
It's important to understand the difference between DNS record sets and individual DNS records. A record set is a collection of records in a zone that have the same name and are the same type.
A record set cannot contain two identical records. Empty record sets (with zero records) can be created, but do not appear on the Azure DNS name servers. Record sets of type CNAME can contain one record at most.

### DNS for Private Domains
<img src="https://docs.microsoft.com/zh-tw/azure/dns/media/private-dns-overview/scenario.png">
- 設定後可由 <app-name>.azurewebsites.net 連到該 app

### VNet Peering
Perhaps the simplest and quickest way to connect your VNets is to use VNet peering. Virtual network peering enables you to seamlessly (無縫地) connect two Azure virtual networks. Once peered, the virtual networks appear as one, for connectivity purposes.
<br><img src='../../../img/cloud/azure/VNet-peering.png'>
<br><img src="https://miro.medium.com/max/505/1*3tQlWO0d82Vt6oO0G7jbmA.png">
- 軟體定義網路
- 可跨 region, subscription and tenant
    - https://docs.microsoft.com/en-us/azure/virtual-network/create-peering-different-deployment-models-subscriptions
- 資料流出 data center 才要費用

### Gateway Transit and Connectivity
When virtual networks are peered, you can configure a VPN gateway in the peered virtual network as a transit point. In this case, a peered virtual network can use the remote gateway to gain access to other resources. A virtual network can have only one gateway. Gateway transit is supported for both VNet Peering and Global VNet Peering.
<br><img src="https://docs.microsoft.com/en-us/azure/virtual-network/media/virtual-networks-peering-overview/local-or-remote-gateway-in-peered-virual-network.png">

### VPN Gateway
A VPN gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. You can also use a VPN gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. Each virtual network can have only one VPN gateway. However, you can create multiple connections to the same VPN gateway. When you create multiple connections to the same VPN gateway, all VPN tunnels share the available gateway bandwidth.
<br><img src='https://docs.microsoft.com/zh-tw/azure/vpn-gateway/media/tutorial-site-to-site-portal/diagram.png'>
- 要建立 route table
- 當要使用 S2S VPN 時，與地端連
- 預設都用 route-based

### ExpressRoute (專線)
Azure ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a dedicated private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure, Microsoft 365, and CRM Online.
<br><img src='https://docs.microsoft.com/zh-tw/azure/expressroute/media/expressroute-introduction/expressroute-connection-overview.png'>
<br><img src="https://i.pinimg.com/originals/26/79/a3/2679a35f8b6838776609b0563eb7b85c.png">

## 6. Network Traffic Management
### Route Table
- 需同 region 才可適用

### Service Endpoint (VNet Service Endpoints)
A VNet service endpoint provides the identity of your virtual network to the Azure service. Once service endpoints are enabled in your virtual network, you can secure Azure service resources to your VNet by adding a VNet rule to the resources.
- 針對 PaaS 服務建立連線，等於微軟幫忙建立 VPN gateway
- 可以對外連線
- 把 VNet 放到 PaaS 內

### Private Link (Private Endpoint，強化安全版 Service Endpoint)
Azure Private Link provides private connectivity from a VNet to Azure PaaS, customer-owned, or Microsoft partner services. It simplifies the network architecture and secures the connection between endpoints in Azure by eliminating (消除) data exposure to the public internet.
- integration with on-premises and peered networks.​
    <br>Access private endpoints over private peering or VPN tunnels from on-premises or peered VNet. Microsoft hosts the traffic, so you don’t need to set up public peering or use the internet to migrate your workloads to the cloud.
- 把 PaaS 放到 VNet 內
- 設定方式，會產生 VNet NIC
    ```mermaid
    graph LR
        A(App Service) -->|Settings| B(Networking)
        B --> C(Private Endpoint connections)
        C --> D(Virtual Network)
    ```
- https://acloud.guru/forums/az-500-microsoft-azure-security-technologies/discussion/-M5IkN1SzQcDUNRyvaVL/Service%20endpoints%20vs.%20Private%20Endpoints%3F

### Azure Private Endpoint DNS configuration
#### On-premises workloads using a DNS forwarder
For on-premises workloads to resolve the FQDN of a private endpoint, use a DNS forwarder to resolve the Azure service public DNS zone in Azure.
To configure properly, you need the following resources:
- On-premises network
- Virtual network connected to on-premises (VPN)
- DNS forwarder deployed in Azure (建立一台 VM)
- Private DNS zones privatelink.database.windows.net with type A record (設定 PaaS 的 FQDN)
- Private endpoint information (FQDN record name and private IP address)
<br><img src="https://docs.microsoft.com/zh-tw/azure/private-link/media/private-endpoint-dns/on-premises-using-azure-dns.png">


### Azure Load Balancer (Lev 4)
<img src="https://docs.microsoft.com/zh-tw/azure/load-balancer/media/load-balancer-distribution-mode/load-balancer-distribution.png">

### Session Persistence
By default, Azure Load Balancer distributes network traffic equally among multiple VM instances. The load balancer uses a 5-tuple (source IP, source port, destination IP, destination port, and protocol type) hash to map traffic to available servers. It provides stickiness only within a transport session.

Session persistence specifies how traffic from a client should be handled. The default behavior (None) is that successive requests from a client may be handled by any virtual machine. You can change this behavior.

### Application Gateway (Lev 7)
Application Gateway manages the requests that client applications can send to a web app. Application Gateway routes traffic to a pool of web servers based on the URL of a request. This is known as application layer routing. The pool of web servers can be Azure virtual machines, Azure virtual machine scale sets, Azure App Service, and even on-premises servers.

Traditional load balancers operate at the transport layer (OSI layer 4 - TCP and UDP) and route traffic based on source IP address and port, to a destination IP address and port.

The Application Gateway will **automatically load balance** requests sent to the servers in each back-end pool using a round-robin mechanism. However, you can configure session stickiness, if you need to ensure that all requests for a client in the same session are routed to the same server in a back-end pool.
<br><img src="https://docs.microsoft.com/zh-tw/azure/application-gateway/media/overview/figure1-720.png">
<br><img src="https://docs.microsoft.com/zh-tw/azure/application-gateway/media/application-gateway-components/application-gateway-components.png">
<br><img src="https://miro.medium.com/max/1400/0*X38oEgWmuKHRAqVP.png">

## 7. Azure Storage
### Azure Storage Services
- 屬於 IaaS: https://azure.microsoft.com/en-us/overview/what-is-azure/iaas/
- 類型(不可中途改變類型)
    - standard
        <br>They are best for applications that require **bulk storage** or where data is accessed infrequently
    - premium
        <br>They can only be used with Azure virtual machine disks and are best for I/O-intensive applications, like databases
- Azure Containers (Blobs)
    - A massively scalable object store for text and binary data(unstructured data)
    - Objects in Blob storage can be accessed from anywhere in the world via HTTP or HTTPS
- Azure Files
    - Managed file shares for cloud or on-premises deployments.
    - Accessed by using the standard Server Message Block (SMB) protocol
    - Active Directory-based authentication and access control lists (ACLs) are not supported
- Azure Queues
    - Queue service is used to store and retrieve messages
- Azure Tables
    - Table storage is now part of Azure Cosmos DB.

### Securing Storage Endpoints
- firewalls and VNet restricts access to the storage account from specific subnets on VNet or public ip’s.
- subnets and VNet must exist in the same azure region or region pair as the storage account.

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
    <br><img src="https://docs.microsoft.com/zh-tw/azure/azure-monitor/platform/media/autoscale-overview/autoscale_overview_v4.png">

### Virtual Machine Extensions
Azure virtual machine extensions are small applications that provide post-deployment configuration and automation tasks on Azure VMs. For example, if a virtual machine requires software installation, anti-virus protection, or a configuration script inside, a VM extension can be used. Extensions are all about managing your virtual machines.

## 9. Serverless Computing (無伺服器運算)
### App Service Overview
- 不能換 region

### Backup an App Service
備份到 storage account 轉為 blob，此時可以換 region

### Container Service
- containers vs virtual machines

### [Azure Kubernetes Service](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_09c-Implement_Azure_Kubernetes_Service.md)
Kubernetes is a rapidly evolving platform that manages container-based applications and their associated networking and storage components. The focus is on the application workloads (工作量), not the underlying (淺在的) infrastructure components. Kubernetes provides a declarative approach to deployments, backed by a robust (強壯的) set of APIs for management operations.

You can build and run modern, portable, microservices-based applications that benefit from Kubernetes orchestrating and managing the availability of those application components. Kubernetes supports both stateless and stateful applications as teams progress through the adoption of microservices-based applications.

As an open platform, Kubernetes allows you to build your applications with your preferred programming language, OS, libraries, or messaging bus. Existing continuous integration and continuous delivery (CI/CD) tools can integrate with Kubernetes to schedule and deploy releases.

AKS provides a managed Kubernetes service that reduces the complexity for deployment and core management tasks, including coordinating upgrades. The AKS cluster is managed by the Azure platform, and you **only pay for the AKS nodes** that run your applications. AKS is built on top of the open-source Azure Container Service Engine (acs-engine).

AKS makes it simple to deploy a managed Kubernetes cluster in Azure. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading (分流) much of that responsibility to Azure. As a hosted Kubernetes service, Azure handles critical tasks like health monitoring and maintenance for you. In addition, the service is free, you only **pay for the agent nodes** within your clusters.
<br><img src="../../../img/kubernetes/aks-terminology.png" width=500 />
- Pools are groups of nodes with identical configurations.
- Nodes are individual virtual machines running containerized applications.
- Pods are a single instance of an application. A pod can contain multiple containers.
- Container is a lightweight and portable executable image that contains software and all of its dependencies.
- Deployment has one or more identical pods managed by Kubernetes​.
- Manifest (清單文件) is the YAML file describing a deployment.

#### AKS Clusters and Nodes
A Kubernetes cluster is divided into two components:
- Azure-managed nodes, which provide the core Kubernetes services and orchestration (編排) of application workloads.
    <br>When you create an AKS cluster, a cluster node is **automatically** created and configured. This node is provided as a managed Azure resource abstracted from the user. You pay only for running agent nodes.
- Customer-managed nodes that run your application workloads.

#### Nodes and node pools
To run your applications and supporting services, you need a Kubernetes node. An AKS cluster contains one or more nodes (Azure Virtual Machines) that run the Kubernetes node components and the container runtime.
- The kubelet is the Kubernetes agent that processes the orchestration (編排) requests from the Azure-managed node , and scheduling of running the requested containers.
- VNet **is handled by the kube-proxy** on each node. The proxy routes network traffic and manages IP addressing for services and pods.
- The container runtime is the component that allows containerized applications to run and interact with additional resources such as the VNet and storage. In AKS, Docker is used as the container runtime.

#### AKS Networking
#### AKS Storage
#### AKS Service Security
#### AKS Scaling

## 10. Data Protection
### Azure Backup
Azure Backup is the Azure-based service you can use to back up (or protect) and restore your data in the Microsoft cloud. Azure Backup replaces your existing on-premises or off-site backup solution with a cloud-based solution that is reliable, secure, and cost-competiwtive.

### Virtual Machine Data Protection
- azure backup
- azure site recovery
    - 用 recover service 備份 azure resource 時，必須為同 region
- managed disk snapshots

## 11. Monitoring