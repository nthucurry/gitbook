# 1. Azure 基本設定
- 新建 Tenant
- 新建 Subscription
- 新建 Resource Group
- 新建 AAD

## Conditional Access
- Named locations: 設定信任的 IP
- New policy

# 2. 網路配置
## Virtual Network (VNet)
| Type        | Subnet             | CIDR            | NSG             |
|-------------|--------------------|-----------------|-----------------|
| Server Farm | server-farm        | 10.0.0.0/24     | nsg-server-farm |
| DMZ         | AzureBastionSubnet | 10.0.169.0/24   |                 |
| DMZ         | GatewaySubnet      | 10.0.170.0/24   |                 |
| DMZ         | waf                | 10.0.171.0/24   |                 |
| DMZ         | dmz                | 10.0.172.0/26   | nsg-dmz         |
| DMZ         | dmz-app            | 10.0.172.192/27 | nsg-dmz         |
| DMZ         | dmz-apim           | 10.0.172.224/27 | nsg-dmz         |

## Network security groups (NSG)
| Rule    | Name                | Port        | Protocol | Source         | Destination    | Action |
|---------|---------------------|-------------|----------|----------------|----------------|--------|
| Inbound | from_APIM           | 3443        | TCP      | ApiManagement  | VirtualNetwork | Allow  |
| Inbound | from_GatewayManager | 65200-65535 | TCP      | GatewayManager | Any            | Allow  |

# 3. 解析 IP
## 建立 Private DNS Zone
- Basics
    - Instance details: **findarts.net**

## 設定 Virtual network links
- Link name: **vnet**
- Virtual network: **vnet**
- Enable auto registration: **打勾**

# 3. 存放憑證
## 建立 Key Vault
- Basics
    - Key vault name: **findarts**
    - Region: **Japan East**
    - Pricing tier: **Standard**
    - Recovery options: **用預設的**
- Access policy: **用預設的**
- Networking
    - Connectivity method: **Private endpoint**

## 上傳 PFX
- Portal 位置
    - Settings → Certificates → Generate/Import
- Method of Certificate Creation: **Import**
- Certificate Name: **certificate-private-api**
- Upload Certificate File
- Password: **1234**

## 產生測試用憑證
- [SSL for Free](https://www.sslforfree.com/)
    - 引導式設定
- 產生 PFX 憑證
    - `openssl pkcs12 -export -out certificate-private.pfx -inkey private.key -in certificate.crt`

[Back to top](#)
# 4. FindARTs Portal
## 建立 App Service
- Instance Details
    - Publish: **Code**
    - Runtime stack: **PHP 8.0**
    - Operating System: **Linux**
    - Region: **Japan East**
- App Service Plan
    - Sku and size: **Premium V2 P1v2**
- GitHub Actions settings
    - Continuous deployment: **Disable**
- Networking (preview)
    - Enable network injection: **Off**
- Monitoring
    - Enable Application Insights: **No**

## 設定內網
- Networking
    - Add Private Endpoint
    - Integrate with private DNS zone: **Yes**
- VNet Integration
    - Add VNet: **dmz-app**

## 設定 Custom Domains
- Add custom domain
    - 輸入 Custom domain: findarts.net
    - 將 Custom Domain Verification ID 記錄已購買的 DNS Provider

[Back to top](#)
# 5. FindARTs API/Web 管理平台
## 建立 API Management (APIM)
- Basics
    - Project details
        - Resource group: Infra
    - Instance details
        - Region: **Japan East**
        - Resource name: **findarts-apim**
        - Organization name: **FindARTs**
        - Administrator email: **tony.lee@findarts.onmicrosoft.com**
    - Pricing tier: **Developer (no SLA)** (佈署後可再調整)
- Monitoring
    - Application Insights: **None** (佈署後可再調整)
- Scale: **Developer 無法使用**
- Managed identity
    - System assigned managed identity: **None**
- Virtual network
    - Connectivity type: **Virtual network**
    - Type: **Internal**
    - Subnet: **dmz-apim**
- Protocol settings: **None**

## 設定 Custom Domain
- Type: **Gateway**
- Hostname: **api.findarts.net**
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
        - Enable autoscaling: **Yes** (佈署後可再調整)
        - Minimum / Maximum instance count: **1/10** (佈署後可再調整)
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

[Back to top](#)
## 匯入憑證
- Listener (API)
    - Listener name: **listener_443_api.findarts.net**
    - Frontend IP: **Public**
    - Protocol: **HTTPS**
    - Port: **443**
    - Choose a certificate: **certificate-private.pfx** (Create new)
    - Listener type: **Multi site**
    - Host type: **Multiple/Wildcard**
        - Host names: **api.findarts.net**
    - Min protocol version: **TLSv1_2**
- Listener (Portal)
    - Listener name: **listener_443_www.findarts.net**
    - Frontend IP: **Public**
    - Protocol: **HTTPS**
    - Port: **443**
    - Choose a certificate: **certificate-private-portal.pfx** (Create new)
    - Listener type: **Multi site**
    - Host type: **Multiple/Wildcard**
        - Host names: **www.findarts.net**
        - Host names: **findarts.net**
    - Min protocol version: **TLSv1_2**

## 設定 Private DNS Zone
| FQDN                                   | IP           |
|----------------------------------------|--------------|
| findarts-apim.developer.azure-api.net  | 10.0.172.229 |
| findarts-apim.azure-api.net            | 10.0.172.229 |
| findarts-apim.management.azure-api.net | 10.0.172.229 |
| findarts-apim.portal.azure-api.net     | 10.0.172.229 |
| findarts-apim.scm.azure-api.net        | 10.0.172.229 |

## Backend settings
- Backend settings name: **bs_443_www.findarts.net**
- Backend protocol: **HTTPS**
- Use well known CA certificate: **Yes**
- Use custom probe: **Yes**
- Custom probe: **hp_443_www.findarts.net**

[Back to top](#)
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
        - Resource group: **Infra**
    - Instance details
        - Name: **vpn-gateway**
        - Region: **Japan East**
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

# 9. VM
- 安裝 NGINX
    - `yum install epel-release -y`
    - `yum install nginx -y`
    - `systemctl enable nginx.service --now`
- 設定憑證
    - `openssl pkcs12 -export -out cert.pfx -inkey private.key -in cert.crt`
- [參數設定](https://github.com/ShaqtinAFool/gitbook/blob/master/infra/nginx.md)
- 重啟 NGINX 服務

# 10. 備份服務
## 建立 Backup Vault (IaaS)
- Basics
    - Project details
        - Resource group: **Production**
    - Instance details
        - Backup vault name:
        - Region: **Japan East**
        - Backup storage redundancy: **Locally-redundant**

## 建立 SQL Database 備份 (PaaS)
## 建立 Cache Redis DB 備份 (PaaS)
# 11. Log 收集與監控
# 12. VM 服務高可用性 (Option)