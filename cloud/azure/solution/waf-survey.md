- [Reference](#reference)
- [Architecture](#architecture)
- [Cost](#cost)
    - [Azure WAF (v1 vs v2)](#azure-waf-v1-vs-v2)
    - [FortiWeb (WaaS vs VM)](#fortiweb-waas-vs-vm)
- [FortiWeb Web Application Firewall](#fortiweb-web-application-firewall)
- [FortoWeb Cloud](#fortoweb-cloud)

# Reference
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with FortiWeb Web Application Firewall](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/fortiweb-web-application-firewall-tutorial)
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with Palo Alto Networks - GlobalProtect](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/palo-alto-networks-globalprotect-tutorial)
- [Fortinet FortiWeb vs Microsoft Azure Application Gateway comparison](https://www.peerspot.com/products/comparisons/fortinet-fortiweb_vs_microsoft-azure-application-gateway)

# Architecture
<br><img src="https://docs.microsoft.com/en-us/azure/web-application-firewall/media/ag-overview/waf1.png"  width=600>

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

# FortiWeb Web Application Firewall
- Vulnerability scanning
- IP reputation, attack signatures, and antivirus powered by FortiGuard
- Behavioral attack detection, threat scanning, protection against botnets (殭屍網絡), DDoS, automated attacks, and more
- Integration with FortiSandbox for advanced threat protection (ATP) detection
- Tools to give you valuable insights on attacks
- Available in the Azure Marketplace

# FortoWeb Cloud
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/2ffc9903-bcb4-11e9-8977-00505692583a/images/2468b3e46f186060c6c4268e2efbb20b_traffic-flow.png" width=600>