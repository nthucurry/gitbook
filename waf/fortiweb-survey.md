- [Reference](#reference)
- [Architecture](#architecture)
    - [Application Gateway after firewall](#application-gateway-after-firewall)
    - [Topology for Reverse Proxy mode](#topology-for-reverse-proxy-mode)
    - [Topology for either of the transparent modes](#topology-for-either-of-the-transparent-modes)
- [SOP on Azure](#sop-on-azure)
    - [1. Create Interface](#1-create-interface)
    - [2. Create Virtual IP](#2-create-virtual-ip)
    - [3. Create Virtual Server (WAF Subnet)](#3-create-virtual-server-waf-subnet)
    - [4. Create Server Pool (Web Subnet)](#4-create-server-pool-web-subnet)
    - [5. Create HTTP Server Policy](#5-create-http-server-policy)
- [Deploy highly available NVAs (Network Virtual Appliances)](#deploy-highly-available-nvas-network-virtual-appliances)
    - [HA architectures overview](#ha-architectures-overview)
- [Option](#option)
    - [~~FortoWeb Cloud~~](#fortoweb-cloud)
    - [架構圖](#架構圖)

# Reference
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with FortiWeb Web Application Firewall](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/fortiweb-web-application-firewall-tutorial)
- [Tutorial: Azure Active Directory single sign-on (SSO) integration with Palo Alto Networks - GlobalProtect](https://docs.microsoft.com/en-us/azure/active-directory/saas-apps/palo-alto-networks-globalprotect-tutorial)
- [Fortinet FortiWeb vs Microsoft Azure Application Gateway comparison](https://www.peerspot.com/products/comparisons/fortinet-fortiweb_vs_microsoft-azure-application-gateway)
- [fortinet/azure-templates](https://github.com/fortinet/azure-templates)
- [FortiWeb on OCB-FE Configuration Guide](https://cloud.orange-business.com/wp-content/uploads/2020/08/FortiWeb_on_OCB_FE_Configuration_Guide.pdf)
- [Configuring FortiWeb-VMs](https://docs.fortinet.com/document/fortiweb-public-cloud/latest/use-case-high-availability-for-fortiweb-on-azure/425287/configuring-fortiweb-vms)
- [Azure Route Server](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/nva-ha?tabs=cli#azure-route-server)

# Architecture
## [Application Gateway after firewall](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/gateway/firewall-application-gateway#application-gateway-after-firewall)
<br><img src="https://docs.microsoft.com/en-us/azure/architecture/example-scenario/gateway/images/design5_500.png" width=500>

- [Network Virtual Appliance (NVA)](https://aviatrix.com/learn-center/cloud-security/azure-network-virtual-appliance/)
    - NVA is used in the Azure application to enhance HA. It is used as an advanced level of control over traffic flows, such as when building a DMZ in the cloud.
    <br><img src="https://2ujst446wdhv3307z249ttp0-wpengine.netdna-ssl.com/wp-content/uploads/2020/08/nva-image-1.png" width=600>

## Topology for Reverse Proxy mode
Requests are destined for a virtual server’s network interface and IP on FortiWeb, **not a web server directly.** FortiWeb usually applies full NAT. FortiWeb applies the first applicable policy, then forwards permitted traffic to a web server. FortiWeb logs, blocks, or modifies violations according to the matching policy.

## Topology for either of the transparent modes
No changes to the IP address scheme of the network are required. **Requests are destined for a web server, not the FortiWeb appliance.** More features are supported than offline protection mode, but fewer than reverse proxy, and may vary if you use HTTPS.

Unlike with Reverse Proxy mode, with both transparent modes, web servers will see the source IP address of clients.
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/2c7f658f-7d40-11ec-a0d0-fa163e15d75b/images/8b09d5940b397fd4084c47f7b74a84a6_network_topology_transparent.png">

# SOP on Azure
<br><img src="https://yurisk.info/assets/fortiweb-basic-setup.svg" width=400>

## 1. Create Interface
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-1-interfce.png" width=800>

## 2. Create Virtual IP
The VIPs are the IPs that paired with the domain name of your application. When users visit your application, the destination of their requests are these IPs.

You can later attach one or more **VIPs** to a virtual server, and then reference the **virtual server** in a **server policy**. The **web protection profile** in the server policy will be applied to all the virtual IPs attached to this virtual server.

<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-2-virtual-ip.png" width=800>

## 3. Create Virtual Server (WAF Subnet)
- 注意事項
    - A virtual server is more similar to a VIP on a FortiGate. It is **not** an actual server, but simply defines the listening network interface. Unlike a FortiGate VIP, it includes a specialized proxy that only picks up HTTP and HTTPS.
    - By default, in Reverse Proxy mode, FortiWeb’s virtual servers do not forward non-HTTP/HTTPS traffic from virtual servers to your protected web servers.

<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-3-virtual-server-1.png" width=800>
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-3-virtual-server-2.png" width=800>

## 4. Create Server Pool (Web Subnet)
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-4-server-pool.png" width=800>

## 5. Create HTTP Server Policy
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-5-server-policy.png" width=800>

# Deploy highly available NVAs (Network Virtual Appliances)
- To inspect egress traffic from VMs to the Internet and prevent data exfiltration (滲出).
- To inspect ingress traffic from the Internet to VMs and prevent attacks.
- To filter traffic between VMs in Azure, to prevent lateral moves of compromised systems.
- To filter traffic between on-premises systems and Azure virtual machines, if they are considered to belong to different security levels. (For example, if Azure hosts the DMZ, and on-premises the internal applications.)

## HA architectures overview

# Option
## ~~FortoWeb Cloud~~
|       | WaaS                         | VM*                              |
|-------|------------------------------|----------------------------------|
| Type  | SaaS                         | IaaS                             |
| Price | PAYG (traffic)               | PAYG (CPU)                       |
|       | traffic: NT$12/GB            | 2 vCPU: NT$24.9/hr, NT$18,177/mo |
|       | site number: NT$0.9/one site | 8 vCPU: NT$106/hr, NT$77,380/mo  |
- The PAYG license includes a WAF license, a FortiCare subscription (includes Security signatures, IP Reputation and Antivirus) and support
- 還需另外估算 VM & 磁碟費用

## 架構圖
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/541c4d24-4c4a-11e9-94bf-00505692583a/images/18ad94c87b26bfff643c1013ab78f5c8_auto-scaling.png" width=800>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/d99c9968-125b-11e9-b86b-00505692583a/images/7d3cc123897522bcede6eaaadfa51258_azureha.jpg.png" width=800>
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/0489513b-b3c1-11e9-a989-00505692583a/images/c7bc702000cf29097183e1f6c6ee8555_fig-AzureAS-PAYGonly.png" width=800>
<br><img src="https://raw.githubusercontent.com/fortinet/azure-templates/main/FortiWeb/Active-Passive/images/fwb-active-passive.png" width=800>
<br><img src="https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/images/nva-ha/nvaha-pipudr-internet.png" width=800>