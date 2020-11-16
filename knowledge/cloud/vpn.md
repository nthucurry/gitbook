# VPN
## Site to Site VPN connectivity (GCP ⇆ VMware Shared)
### 建立 GCP VPN
- ![VPN connectivity 1](../../img/cloud/gcp/vpn-setting-1.png)
- ![VPN connectivity 2](../../img/cloud/gcp/vpn-setting-2.png)
- ![keep any information](../../img/cloud/gcp/vpn-setting-3.png)
- ![result](../../img/cloud/gcp/vpn-result.png)

### 建立 VMware Shared VPN
- [設定 Edge 閘道的 IPsec VPN 站台連線
](https://docs.vmware.com/tw/VMware-Cloud-Director/9.7/com.vmware.vcloud.tenantportal.doc/GUID-EDFE41C7-C93C-41E7-8437-85163C5278B1.html)
- ![edit VPN](../../img/cloud/ibm/shared-vpn-setting.png)
- ![result](../../img/cloud/ibm/shared-vpn-result.png)

### Confirm
![](../../img/cloud/gcp/vpn-connect-confirm.png?raw=true)

## Point to Site VPN connectivity
### CentOS ⇆ GCP
- [CentOS 架 L2TP/IPsec VPN](http://qbsuranalang.blogspot.com/2016/12/centos-l2tpipsec-vpn.html)
- 安裝 VNC server(需要從 GUI 設定 VPN 資訊)
- `wget https://git.io/vpnsetup-centos -O vpnsetup.sh && sudo sh vpnsetup.sh`
    - ![](../../img/cloud/gcp/vpn-info.png)
- 啟動 IPSec Service
    ```bash
    systemctl start ipsec.service
    systemctl enable ipsec.service
    ```
- 進入 GUI 設定 VPN
    - ![](../../img/cloud/gcp/vpn-linux-gui-setting.png)