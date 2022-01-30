- [Reference](#reference)
- [Architecture](#architecture)
  - [Fortinet FortiWeb Web Application Firewall (WAF)](#fortinet-fortiweb-web-application-firewall-waf)
  - [SOP on Azure](#sop-on-azure)
    - [1. Create Virtual IP](#1-create-virtual-ip)
    - [2. Create Virtual Server](#2-create-virtual-server)
    - [3. Create Protected Hostname](#3-create-protected-hostname)
    - [4. Create Protected Hostname](#4-create-protected-hostname)
    - [5. Create Server Pool](#5-create-server-pool)
    - [6. Create HTTP Server Policy](#6-create-http-server-policy)
- [Option](#option)
  - [~~Azure WAF v2~~](#azure-waf-v2)
  - [~~FortoWeb Cloud~~](#fortoweb-cloud)
  - [~~Imperva WAF Gateway (On Prem WAF) v13~~](#imperva-waf-gateway-on-prem-waf-v13)

# Reference
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with FortiWeb Web Application Firewall](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/fortiweb-web-application-firewall-tutorial)
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with Palo Alto Networks - GlobalProtect](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/palo-alto-networks-globalprotect-tutorial)
- [Fortinet FortiWeb vs Microsoft Azure Application Gateway comparison](https://www.peerspot.com/products/comparisons/fortinet-fortiweb_vs_microsoft-azure-application-gateway)
- [fortinet/azure-templates](https://github.com~`/fortinet/azure-templates)

# Architecture
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/541c4d24-4c4a-11e9-94bf-00505692583a/images/18ad94c87b26bfff643c1013ab78f5c8_auto-scaling.png" width=800>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/d99c9968-125b-11e9-b86b-00505692583a/images/7d3cc123897522bcede6eaaadfa51258_azureha.jpg.png" width=800>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/0489513b-b3c1-11e9-a989-00505692583a/images/c7bc702000cf29097183e1f6c6ee8555_fig-AzureAS-PAYGonly.png" width=800>
<br><img src="https://raw.githubusercontent.com/fortinet/azure-templates/main/FortiWeb/Active-Passive/images/fwb-active-passive.png" width=800>

## Fortinet FortiWeb Web Application Firewall (WAF)
<br><img src="https://yurisk.info/assets/fortiweb-basic-setup.svg">
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/a654c346-45de-11ec-bdf2-fa163e15d75b/images/cdc018b06bc9b59df5d7ec10835b9f68_network_topology_inline.png" width=600>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/9606ca42-fd14-11e8-b86b-00505692583a/images/516c7581095f7922c360bbb9a808c42b_fweb%20for%20azure%20architecture.png" width=600>

## SOP on Azure
### 1. Create Virtual IP
### 2. Create Virtual Server
- 注意事項
    - A virtual server is more similar to a virtual IP on a FortiGate. It is **not** an actual server, but simply defines the listening network interface. Unlike a FortiGate VIP, it includes a specialized proxy that only picks up HTTP and HTTPS.

### 3. Create Protected Hostname
### 4. Create Protected Hostname
### 5. Create Server Pool
### 6. Create HTTP Server Policy

# Option
## ~~Azure WAF v2~~
|       | WAF         | WAF v2                   |
|-------|-------------|--------------------------|
| OWASP | CRS 3.0     | CRS 3.1                  |
|       |             | CRS 3.2 (public preview) |
| Type  |             | Customer Rules           |
| Price | NT$2,850/mo | NT$9,742/mo              |

## ~~FortoWeb Cloud~~
|       | WaaS                         | VM*                              |
|-------|------------------------------|----------------------------------|
| Type  | SaaS                         | IaaS                             |
| Price | PAYG (traffic)               | PAYG (CPU)                       |
|       | traffic: NT$12/GB            | 2 vCPU: NT$24.9/hr, NT$18,177/mo |
|       | site number: NT$0.9/one site | 8 vCPU: NT$106/hr, NT$77,380/mo  |
- The PAYG license includes a WAF license, a FortiCare subscription (includes Security signatures, IP Reputation and Antivirus) and support
- 還需另外估算 VM & 磁碟費用

## ~~Imperva WAF Gateway (On Prem WAF) v13~~