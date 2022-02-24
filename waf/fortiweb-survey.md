- [Reference](#reference)
- [Architecture](#architecture)
  - [Application Gateway after firewall](#application-gateway-after-firewall)
  - [Topology for Reverse Proxy mode](#topology-for-reverse-proxy-mode)
  - [Topology for either of the transparent modes](#topology-for-either-of-the-transparent-modes)
- [SOP on Azure](#sop-on-azure)
  - [Configure of Firewall](#configure-of-firewall)
  - [Create Interface](#create-interface)
  - [Create Virtual IP](#create-virtual-ip)
  - [Create Virtual Server (WAF Subnet)](#create-virtual-server-waf-subnet)
  - [Create Server Pool (Web Subnet)](#create-server-pool-web-subnet)
  - [Create HTTP Server Policy](#create-http-server-policy)
  - [Create Route](#create-route)
- [Deploy highly available NVAs (Network Virtual Appliances)](#deploy-highly-available-nvas-network-virtual-appliances)
  - [HA architectures overview](#ha-architectures-overview)
  - [SNMP](#snmp)
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

- [網路虛擬設備 (NVA)](https://aviatrix.com/learn-center/cloud-security/azure-network-virtual-appliance/)
    - NVA is used in the Azure application to enhance HA. It is used as an advanced level of control over traffic flows, such as when building a DMZ in the cloud.
    - 步驟
        - firewall
        - ~~route table~~
            - subnet: web's private IP
            - address prefix: 0.0.0.0/0
            - next hop type: virtual appliance
            - next hop ip address: 10.1.89.4
        - gateway
            - x.x.x.1: reserved by azure for the default gateway
            - [Are there any restrictions on using IP addresses within these subnets?](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-faq#are-there-any-restrictions-on-using-ip-addresses-within-these-subnets)

    <br><img src="https://2ujst446wdhv3307z249ttp0-wpengine.netdna-ssl.com/wp-content/uploads/2020/08/nva-image-1.png" width=600>

## Topology for Reverse Proxy mode
Requests are destined for a virtual server’s NIC and IP on FortiWeb, **not a web server directly.** FortiWeb usually applies full NAT. FortiWeb applies the first applicable policy, then forwards permitted traffic to a web server. FortiWeb logs, blocks, or modifies violations according to the matching policy.

## Topology for either of the transparent modes
No changes to the IP address scheme of the network are required. **Requests are destined for a web server, not the FortiWeb appliance.** More features are supported than offline protection mode, but fewer than reverse proxy, and may vary if you use HTTPS.

Unlike with Reverse Proxy mode, with both transparent modes, web servers will see the source IP address of clients.
<br><img src="https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/resources/2c7f658f-7d40-11ec-a0d0-fa163e15d75b/images/8b09d5940b397fd4084c47f7b74a84a6_network_topology_transparent.png">

# SOP on Azure
<br><img src="https://yurisk.info/assets/fortiweb-basic-setup.svg" width=400>

## Configure of Firewall
- source: *
- destination addresses: web's public IP
- translated address: web's private IP (ex: 10.1.87.4)

<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-1-firewall-dnat.png" width=800>

## Create Interface
在 FortiWeb VM 新增 NIC (ex: FWB-t-web, port 3)
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-add-nic-on-azure.png" width=800>
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-add-nic-on-fortiweb.png" width=800>

## Create Virtual IP
The VIPs are the IPs that paired with the domain name of your application. When users visit your application, the destination of their requests are these IPs. (應該是從防火牆進來後需指定的 IP, DNAT)

You can later attach one or more **VIPs** to a virtual server, and then reference the **virtual server** in a **server policy**. The **web protection profile** in the server policy will be applied to all the virtual IPs attached to this virtual server.

- 沒接防火牆，是 Public IP
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-2-virtual-ip.png" width=800>
- 有接防火牆，是 Private IP (VIP)
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-2-virtual-ip-tmp.png" width=800>

## Create Virtual Server (WAF Subnet)
A virtual server is more similar to a VIP on a FortiGate. It is **not** an actual server, but simply defines the listening NIC. Unlike a FortiGate VIP, it includes a specialized proxy that only picks up HTTP and HTTPS. (非真實存在)

By default, in Reverse Proxy mode, FortiWeb’s virtual servers do not forward non-HTTP/HTTPS traffic from virtual servers to your protected web servers. [原文說明](https://docs.fortinet.com/document/fortiweb/6.3.0/administration-guide/219671/configuring-virtual-servers-on-your-fortiweb)

<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-3-virtual-server-1.png" width=800>
- 用 interface，成功 (ex: port 1)
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-3-virtual-server-2.png" width=800>
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-3-virtual-server-3.png" width=800>

## Create Server Pool (Web Subnet)
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-4-server-pool.png" width=800>

## Create HTTP Server Policy
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-5-server-policy.png" width=800>

## Create Route
Static routes direct traffic exiting the FortiWeb appliance based upon the packet’s destination—you can specify through which NIC a packet leaves and the IP address of a next-hop router that is reachable from that NIC. ([原文說明](https://docs.fortinet.com/document/fortiweb/6.3.0/administration-guide/55130/configuring-the-network-settings))
- You must configure FortiWeb with at **least one static route** that points to a router, often a router that is the gateway to the Internet.
- gateway: x.x.x.1, reserved by azure for the default gateway

<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/fortiweb/deploy-web-6-route-tmp.png" width=800>

# Deploy highly available NVAs (Network Virtual Appliances)
- To inspect egress traffic from VMs to the Internet and prevent data exfiltration (滲出).
- To inspect ingress traffic from the Internet to VMs and prevent attacks.
- To filter traffic between VMs in Azure, to prevent lateral moves of compromised systems.
- To filter traffic between on-premises systems and Azure virtual machines, if they are considered to belong to different security levels. (For example, if Azure hosts the DMZ, and on-premises the internal applications.)

## HA architectures overview

## SNMP
<br><img src="../img/fortiweb/snmp-enable.png">

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