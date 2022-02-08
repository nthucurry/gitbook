- [Reference](#reference)
- [Architecture](#architecture)
  - [Fortinet FortiWeb Web Application Firewall (WAF)](#fortinet-fortiweb-web-application-firewall-waf)
- [SOP on Azure](#sop-on-azure)
  - [1. Create Virtual IP](#1-create-virtual-ip)
  - [2. Create Virtual Server (WAF Subnet)](#2-create-virtual-server-waf-subnet)
  - [3. Create Protected Hostname](#3-create-protected-hostname)
  - [4. Create Server Pool (Web Subnet)](#4-create-server-pool-web-subnet)
  - [5. Create HTTP Server Policy](#5-create-http-server-policy)
  - [Topology for Reverse Proxy mode](#topology-for-reverse-proxy-mode)
  - [Configuring a bridge (V-zone)](#configuring-a-bridge-v-zone)
- [Option](#option)
  - [~~Azure WAF v2~~](#azure-waf-v2)
  - [~~FortoWeb Cloud~~](#fortoweb-cloud)
  - [~~Imperva WAF Gateway (On Prem WAF) v13~~](#imperva-waf-gateway-on-prem-waf-v13)

# Reference
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with FortiWeb Web Application Firewall](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/fortiweb-web-application-firewall-tutorial)
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with Palo Alto Networks - GlobalProtect](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/palo-alto-networks-globalprotect-tutorial)
- [Fortinet FortiWeb vs Microsoft Azure Application Gateway comparison](https://www.peerspot.com/products/comparisons/fortinet-fortiweb_vs_microsoft-azure-application-gateway)
- [fortinet/azure-templates](https://github.com~`/fortinet/azure-templates)
- [FortiWeb on OCB-FE Configuration Guide](https://cloud.orange-business.com/wp-content/uploads/2020/08/FortiWeb_on_OCB_FE_Configuration_Guide.pdf)

# Architecture
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/541c4d24-4c4a-11e9-94bf-00505692583a/images/18ad94c87b26bfff643c1013ab78f5c8_auto-scaling.png" width=800>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/d99c9968-125b-11e9-b86b-00505692583a/images/7d3cc123897522bcede6eaaadfa51258_azureha.jpg.png" width=800>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/0489513b-b3c1-11e9-a989-00505692583a/images/c7bc702000cf29097183e1f6c6ee8555_fig-AzureAS-PAYGonly.png" width=800>
<br><img src="https://raw.githubusercontent.com/fortinet/azure-templates/main/FortiWeb/Active-Passive/images/fwb-active-passive.png" width=800>

## Fortinet FortiWeb Web Application Firewall (WAF)
- This is an example of a network topology with a load balancer behind a FortiWeb:
    <br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/aa3e5084-99bb-11ea-8862-00505692583a/images/4c2a0f679a188b12ef3acf3d007afaec_network_topology_loadBalancer_after1.png" width=600>
- This is an example network topology for Reverse Proxy mode:
    <br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/a654c346-45de-11ec-bdf2-fa163e15d75b/images/cdc018b06bc9b59df5d7ec10835b9f68_network_topology_inline.png" width=600>
- You deploy FortiWeb-VM in the Microsoft Azure cloud platform as part of a virtual network.
    <br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/9606ca42-fd14-11e8-b86b-00505692583a/images/516c7581095f7922c360bbb9a808c42b_fweb%20for%20azure%20architecture.png" width=600>

# SOP on Azure
<br><img src="https://yurisk.info/assets/fortiweb-basic-setup.svg" width=600>

## 1. Create Virtual IP
The VIPs are the IPs that paired with the domain name of your application. When users visit your application, the destination of their requests are these IPs.

You can later attach one or more **VIPs** to a virtual server, and then reference the **virtual server** in a **server policy**. The **web protection profile** in the server policy will be applied to all the virtual IPs attached to this virtual server.

## 2. Create Virtual Server (WAF Subnet)
- [Server Objects] → [Server] → [Virtual Server] → [Create New]
- 注意事項
    - A virtual server is more similar to a VIP on a FortiGate. It is **not** an actual server, but simply defines the listening network interface. Unlike a FortiGate VIP, it includes a specialized proxy that only picks up HTTP and HTTPS.
    - By default, in Reverse Proxy mode, FortiWeb’s virtual servers do not forward non-HTTP/HTTPS traffic from virtual servers to your protected web servers.

## 3. Create Protected Hostname
## 4. Create Server Pool (Web Subnet)
- [Server Objects] → [Server] → [Server Pool] → [Create HTTP Server Pool]

## 5. Create HTTP Server Policy
- [Policy] → [Server Policy] → [Create HTTP Policy]

## Topology for Reverse Proxy mode
Requests are destined for a virtual server’s network interface and IP on FortiWeb, **not a web server directly**. FortiWeb usually applies full NAT. FortiWeb applies the first applicable policy, then forwards permitted traffic to a web server. FortiWeb logs, blocks, or modifies violations according to the matching policy.

## Configuring a bridge (V-zone)
If you have installed a physical FortiWeb appliance, plug in network cables to connect one of the physical ports in the bridge to your protected web servers, and the other port to the Internet or your internal network.

Because port1 is reserved for connections with your management computer, for physical appliances (實體設備), this means that you must plug cables into at least 3 physical ports:
- port1 to your management computer
- one port to your web servers
- one port to the Internet or your internal network

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