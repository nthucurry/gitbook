- [Reference](#reference)
- [Architecture](#architecture)
- [Vendor](#vendor)
- [Cost](#cost)
  - [Azure WAF (v1 vs v2)](#azure-waf-v1-vs-v2)
  - [FortiWeb (WaaS vs VM)](#fortiweb-waas-vs-vm)
  - [Fortinet FortiWeb Web Application Firewall (WAF)](#fortinet-fortiweb-web-application-firewall-waf)
  - [SOP](#sop)
    - [Configuring virtual servers on your FortiWeb](#configuring-virtual-servers-on-your-fortiweb)
  - [Configuring a server policy](#configuring-a-server-policy)
- [FortoWeb Cloud](#fortoweb-cloud)
- [~~Imperva WAF Gateway (On Prem WAF) v13~~](#imperva-waf-gateway-on-prem-waf-v13)

# Reference
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with FortiWeb Web Application Firewall](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/fortiweb-web-application-firewall-tutorial)
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with Palo Alto Networks - GlobalProtect](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/palo-alto-networks-globalprotect-tutorial)
- [Fortinet FortiWeb vs Microsoft Azure Application Gateway comparison](https://www.peerspot.com/products/comparisons/fortinet-fortiweb_vs_microsoft-azure-application-gateway)
- [fortinet/azure-templates](https://github.com~`/fortinet/azure-templates)

# Architecture
<br><img src="https://docs.microsoft.com/en-us/azure/web-application-firewall/media/ag-overview/waf1.png"  width=600>

# Vendor
- Fortinet
    - [技成科技股份有限公司](https://www.mcsi.com.tw/product_list/?id=16)
- ~~Imperva~~
    - [蓋亞資訊](https://www.gaia.net/tc/brands_detail/%E5%93%81%E7%89%8C%E7%B8%BD%E8%A6%BD/3/5/imperva)

# Cost
## Azure WAF (v1 vs v2)
|       | WAF         | WAF v2                   |
|-------|-------------|--------------------------|
| OWASP | CRS 3.0     | CRS 3.1                  |
|       |             | CRS 3.2 (public preview) |
| Type  |             | Customer Rules           |
| Price | NT$2,850/mo | NT$9,742/mo              |

## FortiWeb (WaaS vs VM)
|       | WaaS                         | VM*                              |
|-------|------------------------------|----------------------------------|
| Type  | SaaS                         | IaaS                             |
| Price | PAYG (traffic)               | PAYG (CPU)                       |
|       | traffic: NT$12/GB            | 2 vCPU: NT$24.9/hr, NT$18,177/mo |
|       | site number: NT$0.9/one site | 8 vCPU: NT$106/hr, NT$77,380/mo  |
- The PAYG license includes a WAF license, a FortiCare subscription (includes Security signatures, IP Reputation and Antivirus) and support
- 還需另外估算 VM & 磁碟費用

## Fortinet FortiWeb Web Application Firewall (WAF)
<br><img src="https://yurisk.info/assets/fortiweb-basic-setup.svg">
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/a654c346-45de-11ec-bdf2-fa163e15d75b/images/cdc018b06bc9b59df5d7ec10835b9f68_network_topology_inline.png" width=600>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/9606ca42-fd14-11e8-b86b-00505692583a/images/516c7581095f7922c360bbb9a808c42b_fweb%20for%20azure%20architecture.png" width=600>

## SOP
### Configuring virtual servers on your FortiWeb
- 注意事項
    - A virtual server is more similar to a virtual IP on a FortiGate. It is **not** an actual server, but simply defines the listening network interface. Unlike a FortiGate VIP, it includes a specialized proxy that only picks up HTTP and HTTPS.

## Configuring a server policy

# FortoWeb Cloud
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/2ffc9903-bcb4-11e9-8977-00505692583a/images/2468b3e46f186060c6c4268e2efbb20b_traffic-flow.png" width=600>

# ~~Imperva WAF Gateway (On Prem WAF) v13~~