- [Site to Site VPN connectivity (GCP ⇆ VMware Shared)](#site-to-site-vpn-connectivity-gcp--vmware-shared)
    - [GCP VPN](#gcp-vpn)
    - [VMware Shared VPN](#vmware-shared-vpn)
    - [Azure VPN Gateway](#azure-vpn-gateway)
    - [Confirm](#confirm)
- [Point to Site VPN connectivity](#point-to-site-vpn-connectivity)
    - [CentOS ⇆ GCP](#centos--gcp)

# Site to Site VPN connectivity (GCP ⇆ VMware Shared)
## GCP VPN
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-setting-1.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-setting-2.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-setting-3.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-result.png">

## VMware Shared VPN
- [設定 Edge 閘道的 IPsec VPN 站台連線](https://docs.vmware.com/tw/VMware-Cloud-Director/9.7/com.vmware.vcloud.tenantportal.doc/GUID-EDFE41C7-C93C-41E7-8437-85163C5278B1.html)
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/ibm/shared-vpn-setting.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/ibm/shared-vpn-result.png">

## Azure VPN Gateway
- source
    - Overview
        - SKU: VpnGw2
        - Gateway type: VPN
        - VPN type: Route-based
        - Virtual network: vnet-test
        - Public IP address: 104.215.159.133 (vpn-test-ip)
    - Configuration
        - Generation: Generation2
        - SKU: VpnGw2
        - Active-active mode: Disabled
    - Connection
        - Peer: LocalNetworkGateway
- target
    - Overview
        - Virtual network: vnet-test
        - Virtual network gateway: vpn-test (104.215.159.133)
        - Local network gateway: LocalNetworkGateway (35.247.152.118)
    - Shared key (PSK): IKE Key
    - Configuration
        - Use Azure Private IP Address: Disabled
        - BGP: Disabled
        - IPsec / IKE policy: Default
        - Use policy based traffic selector: Disabled
        - Connection Mode: Default
        - IKE Protocol: IKEv2
    - Properties
        - Connection type: Site-to-site (IPsec)

## Confirm
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-connect-confirm.png">

# Point to Site VPN connectivity
## CentOS ⇆ GCP
- [CentOS 架 L2TP/IPsec VPN](http://qbsuranalang.blogspot.com/2016/12/centos-l2tpipsec-vpn.html)
- 安裝 VNC server(需要從 GUI 設定 VPN 資訊)
- `wget https://git.io/vpnsetup-centos -O vpnsetup.sh && sudo sh vpnsetup.sh`
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-info.png">
- 啟動 IPSec Service
    ```bash
    systemctl start ipsec.service
    systemctl enable ipsec.service
    ```
- 進入 GUI 設定 VPN
    <br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/gcp/vpn-linux-gui-setting.png">