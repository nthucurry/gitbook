- [Reference](#reference)
- [VPN Gateway](#vpn-gateway)
    - [Use IPsec-VPN and CEN to build a high-quality global network](#use-ipsec-vpn-and-cen-to-build-a-high-quality-global-network)
- [Cloud Enterprise Network (CEN)](#cloud-enterprise-network-cen)
    - [Pricing Billing](#pricing-billing)
    - [Build an enterprise-class hybrid cloud by combining multiple connection services](#build-an-enterprise-class-hybrid-cloud-by-combining-multiple-connection-services)
- [Global Accelerator](#global-accelerator)
    - [全球加速联动本地 VPN 网关加速跨国协作](#全球加速联动本地-vpn-网关加速跨国协作)

# Reference
- [Setup IPSec Tunnel between Microsoft Azure and Alibaba Cloud with VPN Gateway](https://www.alibabacloud.com/blog/setup-ipsec-tunnel-between-microsoft-azure-and-alibaba-cloud-with-vpn-gateway_593919)

# [VPN Gateway](https://www.alibabacloud.com/tc/product/vpn-gateway/pricing)
VPN Gateway is an Internet-based service that establishes a connection between a VPC and your on-premise data center.

The communication performance depends on the quality of the Internet connection. If you require higher communication quality, we **recommend** that you use **Cloud Enterprise Network (CEN)** to connect your networks.
|          Type          | Singapore |   China   |    HK     |
|:----------------------:|:---------:|:---------:|:---------:|
| Instance Configuration | $62.64/Mo | $42.48/Mo | $62.64/Mo |
| Public Network Traffic | $0.117/GB | $0.125/GB | $0.156/GB |
|     Peak Bandwidth     |  10Mbps   |  10Mbps   |  10Mbps   |
<br><img src="https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/7297219951/p3319.png">

## [Use IPsec-VPN and CEN to build a high-quality global network](https://www.alibabacloud.com/help/doc-detail/110822.htm?spm=a2c63.p38356.b99.90.5a991350fDF1EY)
<br><img src="https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/2641114851/p71266.png">

# [Cloud Enterprise Network (CEN)](https://www.alibabacloud.com/help/tc/doc-detail/59870.htm)
- CEN instances
    - CEN instances are basic network resources that are used to create and manage interconnected networks.
    - After you create a CEN instance, you can connect different networks by attaching them to the CEN instance. To connect networks deployed on a global scale, you must **purchase** a bandwidth plan and allocate bandwidth for cross-region connections.
- Network instances
    - Network instances that are attached to a CEN instance can communicate with each other. You can attach the following network instances to a CEN instance: VPCs, virtual border routers (VBRs) and Cloud Connect Network (CCN) instances.
- Bandwidth plans
    - No bandwidth plan is required if you want to connect network instances within the same region. To connect network instances in different regions, you must **purchase** a bandwidth plan for the areas to which the networks belong and allocate bandwidth for cross-region connections. Each area contains one or more Alibaba Cloud regions. You can view the supported areas in the CEN console.

## [Pricing Billing](https://www.alibabacloud.com/help/zh/doc-detail/64650.htm?spm=a2796.11534813.8215766810.28.1bd4d7d2cVerUx)
- 购买带宽包

## [Build an enterprise-class hybrid cloud by combining multiple connection services](https://www.alibabacloud.com/help/doc-detail/101136.htm?spm=a2c63.p38356.b99.105.4f047100C8mZu3)
<br><img src="https://help-static-aliyun-doc.aliyuncs.com/assets/img/83131/156508652235239_en-US.png">
<br><img src="https://img.alicdn.com/tfs/TB1gRqPHYrpK1RjSZTEXXcWAVXa-1530-1140.png">

# Global Accelerator
| Specification | Price |
|:-------------:|:-----:|
|    Small I    | $165  |
|   Medium I    | $765  |

## [全球加速联动本地 VPN 网关加速跨国协作](https://www.alibabacloud.com/help/zh/doc-detail/160672.htm?spm=a2c63.p38356.b99.81.58565d5dtsfOEf)
<br><img src="https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/7263473361/p84077.png">
<br><img src="https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/3520358951/p96634.png">◊