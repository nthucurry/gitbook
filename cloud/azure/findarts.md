- [1. 基礎建置](#1-基礎建置)
    - [Virtual Network (VNet)](#virtual-network-vnet)
    - [Network security groups (NSG)](#network-security-groups-nsg)
- [2. FindARTs Portal](#2-findarts-portal)
    - [建立 App Service](#建立-app-service)
    - [設定 Custom Domains](#設定-custom-domains)
- [3. FindARTs API Management](#3-findarts-api-management)
    - [建立 API Management (APIM)](#建立-api-management-apim)
    - [設定 Custom Domain](#設定-custom-domain)
- [4. Applicate Gateway (WAF)](#4-applicate-gateway-waf)
    - [所有對內流量經由 Azure WAF 保護](#所有對內流量經由-azure-waf-保護)
        - [APIM](#apim)
        - [App Service](#app-service)
- [5. VPN 連線](#5-vpn-連線)
- [6. Log 收集與監控](#6-log-收集與監控)
- [7. 備份](#7-備份)
- [8. VM 服務高可用性 (Option)](#8-vm-服務高可用性-option)

---

# 1. 基礎建置
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

# 2. FindARTs Portal
## 建立 App Service
- Instance Details
    - Publish: Code
    - Runtime stack: PHP 8.0
    - Operating System: Linux
    - Region:Southeast Asia
- App Service Plan
    - Sku and size: Premium V2 P1v2
- GitHub Actions settings
    - Continuous deployment: Disable
- Networking (preview)
    - Enable network injection: Off
- Monitoring
    - Enable Application Insights: No

## 設定 Custom Domains
- Add custom domain
    - 輸入 Custom domain: findarts.tech
    - 將 Custom Domain Verification ID 記錄已購買的 DNS Provider


# 3. FindARTs API Management
## 建立 API Management (APIM)
- 先決條件
    - NSG
        - 設定 inbound: ApiManagement → VirtualNetwork (TCP, 3443)
        - inbound: GatewayManager → Any (TCP, 65200-65535)
    - VNet: subnet 選 waf
- 部署 Azure WAF
    - Tier: WAF V2
    - Frontends
    - Routing rules
    - Listener
    - Backend pools
- APIM
    - 需使用 Premium 或 Developer 版本
- VM

## 設定 Custom Domain

# 4. Applicate Gateway (WAF)
## 所有對內流量經由 Azure WAF 保護
### APIM
### App Service

# 5. VPN 連線
- VPN Gateway
- AAD VPN Client

# 6. Log 收集與監控

# 7. 備份

# 8. VM 服務高可用性 (Option)
