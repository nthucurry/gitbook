- [1. Azure 基本設定](#1-azure-基本設定)
- [2. 網路配置](#2-網路配置)
  - [Virtual Network (VNet)](#virtual-network-vnet)
  - [Network security groups (NSG)](#network-security-groups-nsg)
- [3. 存放憑證](#3-存放憑證)
  - [建立 Key Vault](#建立-key-vault)
  - [上傳 PFX](#上傳-pfx)
- [4. FindARTs Portal](#4-findarts-portal)
  - [建立 App Service](#建立-app-service)
  - [設定 Custom Domains](#設定-custom-domains)
- [5. FindARTs API/Web 管理平台](#5-findarts-apiweb-管理平台)
  - [建立 API Management (APIM)](#建立-api-management-apim)
  - [設定 Custom Domain](#設定-custom-domain)
- [6. FindARTs API 防火牆](#6-findarts-api-防火牆)
  - [建立 Applicate Gateway (WAF)](#建立-applicate-gateway-waf)
- [7. FindARTs 內部 & 外部 Storage](#7-findarts-內部--外部-storage)
  - [建立 Storage Account](#建立-storage-account)
- [8. VPN 通道](#8-vpn-通道)
  - [建立 AAD P2S VPN 連線](#建立-aad-p2s-vpn-連線)
  - [建立 VPN Gateway](#建立-vpn-gateway)
- [9. 備份服務](#9-備份服務)
  - [建立 Backup Vault (IaaS)](#建立-backup-vault-iaas)
  - [建立 SQL Database 備份 (PaaS)](#建立-sql-database-備份-paas)
  - [建立 Cache Redis DB 備份 (PaaS)](#建立-cache-redis-db-備份-paas)
- [10. Log 收集與監控](#10-log-收集與監控)
- [11. VM 服務高可用性 (Option)](#11-vm-服務高可用性-option)

---

# 1. Azure 基本設定
- 新建 Tenant
- 新建 Subscription
- 新建 Resource Group
- 新建 AAD

# 2. 網路配置
## Virtual Network (VNet)
| Subnet             | CIDR            | NSG             |
|--------------------|-----------------|-----------------|
| server-farm        | 10.0.0.0/24     | nsg-server-farm |
| AzureBastionSubnet | 10.0.169.0/24   |                 |
| GatewaySubnet      | 10.0.170.0/24   |                 |
| waf                | 10.0.171.0/24   |                 |
| dmz                | 10.0.172.0/26   | nsg-dmz         |
| dmz-app            | 10.0.172.192/27 | nsg-dmz         |
| dmz-apim           | 10.0.172.224/27 | nsg-dmz         |

## Network security groups (NSG)
| Rule    | Name                | Port        | Protocol | Source         | Destination    | Action |
|---------|---------------------|-------------|----------|----------------|----------------|--------|
| Inbound | from_APIM           | 3443        | TCP      | ApiManagement  | VirtualNetwork | Allow  |
| Inbound | from_GatewayManager | 65200-65535 | TCP      | GatewayManager | Any            | Allow  |

# 3. 存放憑證
## 建立 Key Vault
- Basics
    - Key vault name: **findarts**
    - Region: **Southeast Asia**
    - Pricing tier: **Standard**
    - Recovery options: **用預設的**
- Access policy: **用預設的**
- Networking
    - Connectivity method: **Private endpoint**

## 上傳 PFX
- 位置
    - Settings → Certificates → Generate/Import
- Method of Certificate Creation: **Import**
- Certificate Name: **certificate-private-api**
- Upload Certificate File
- Password: **1234**

[Back to top](#)
# 4. FindARTs Portal
## 建立 App Service
- Instance Details
    - Publish: **Code**
    - Runtime stack: **PHP 8.0**
    - Operating System: **Linux**
    - Region: **Southeast Asia**
- App Service Plan
    - Sku and size: **Premium V2 P1v2**
- GitHub Actions settings
    - Continuous deployment: **Disable**
- Networking (preview)
    - Enable network injection: **Off**
- Monitoring
    - Enable Application Insights: **No**

## 設定 Custom Domains
- Add custom domain
    - 輸入 Custom domain: findarts.tech
    - 將 Custom Domain Verification ID 記錄已購買的 DNS Provider

[Back to top](#)
# 5. FindARTs API/Web 管理平台
## 建立 API Management (APIM)
- Basics
    - Project details
        - Resource group: Infra
    - Instance details
        - Region: **Southeast Asia**
        - Resource name: **findarts-apim**
        - Organization name: **FindARTs**
        - Administrator email: **tony.lee@auo.com**
    - Pricing tier: **Developer (no SLA)**
- Monitoring
    - Application Insights: **None** (佈署後可再調整)
- Scale: **Developer 無法使用**
- Managed identity
    - System assigned managed identity: **None**
- Virtual network
    - Connectivity type: **Virtual network**
    - Type: **External**
    - Subnet: **dmz-apim**
- Protocol settings: **None**

## 設定 Custom Domain
- Type: **Gateway**
- Hostname: **api.findarts.tech**
- Certificate
    - Key Vault
        - Certificate key vault id: **https://findarts.vault.azure.net/secrets/certificate-private-api**
        - Clinet identidy: **System assigned identity**

[Back to top](#)
# 6. FindARTs API 防火牆
## 建立 Applicate Gateway (WAF)
- Basics
    - Resource group:  **Infra**
    - Application gateway name: **findarts-waf**
    - Instance details
        - Tier: **WAF V2**
        - Enable autoscaling: **No** (佈署後可再調整)
        - Minimum / Maximum instance count: **1/1** (佈署後可再調整)
        - Availability zone: **None**
        - HTTP2: **Disabled**
        - WAF Policy: **policy** (Create new)
        - Virtual network / Subnet: **vnet / waf**
- Frontends
    - Frontend IP address type: **Public**
    - Public IP address: **findarts-waf** (Add new)
- Backends
    - Name: **findarts-apim**
    - Add backend pool without targets: **Yes**
- Configuration
    - Routing rules
    - Listener
        - Frontend IP
        - Protocol: **HTTP**
        - Port: **80**
    - Backend targets: **findarts-apim**

# 7. FindARTs 內部 & 外部 Storage
## 建立 Storage Account

[Back to top](#)
# 8. VPN 通道
## 建立 AAD P2S VPN 連線
- 直接按照官網文件建置即可
    - [Create an Azure AD tenant for P2S OpenVPN protocol connections](https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant)
    - [Configure an Azure VPN Client - Azure AD authentication - Windows](https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-client)

## 建立 VPN Gateway
- Basics
    - Project details
        - Resource group: Infra
    - Instance details
        - Name: **vpn-gateway**
        - Region: **Southeast Asia**
        - Gateway type: **VPN**
        - VPN type: **Route-based**
        - SKU: **VpnGw1** (佈署後可再調整)
        - Generation: **Generation2**
        - Virtual network / Subnet: **vnet / GatewaySubnet**
    - Public IP address
        - Public IP address name: **vpn-gateway**
        - Availability zone: **Zone-redundant**
        - Enable active-active mode: **Disabled**
        - Configure BGP: **Disabled**

# 9. 備份服務
## 建立 Backup Vault (IaaS)
- Basics
    - Project details
        - Resource group: **Production**
    - Instance details
        - Backup vault name:
        - Region: **Southeast Asia**
        - Backup storage redundancy: **Locally-redundant**

## 建立 SQL Database 備份 (PaaS)
## 建立 Cache Redis DB 備份 (PaaS)

# 10. Log 收集與監控

# 11. VM 服務高可用性 (Option)