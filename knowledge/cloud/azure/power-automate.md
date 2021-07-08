- [On-premises data gateway](#on-premises-data-gateway)
- [RPA (Robotic Process Automation)](#rpa-robotic-process-automation)
- [Power Automate Desktop architecture](#power-automate-desktop-architecture)
    - [Attended/Unattended desktop direct connectivity to the cloud service](#attendedunattended-desktop-direct-connectivity-to-the-cloud-service)
    - [Attended/Unattended desktop connectivity to the cloud service using the on-premises data gateway](#attendedunattended-desktop-connectivity-to-the-cloud-service-using-the-on-premises-data-gateway)
    - [Session credential lifecycle](#session-credential-lifecycle)
- [What is Azure Relay?](#what-is-azure-relay)
- [Reference](#reference)
- [架構](#架構)

# On-premises data gateway
The on-premises data gateway acts as a bridge to provide quick and secure data transfer between on-premises data (data that isn't in the cloud) and several Microsoft cloud services.

These cloud services include Power BI, Power Apps, Power Automate, Azure Analysis Services, and Azure Logic Apps. By **using a gateway**, organizations can **keep** databases and other data sources **on their on-premises networks**, yet securely use that on-premises data in cloud services.

# RPA (Robotic Process Automation)
將枯燥乏味的重複工作 (例如前台系統活動) 自動化，以專注於更高價值的工作。透過半自動 RPA，人員可以啟動工作或回應特定的提示 (例如提供是/否回應)。

# [Power Automate Desktop architecture](https://docs.microsoft.com/zh-tw/power-automate/desktop-flows/pad-architecture)
針對 job flow，Power Automate Desktop 有兩種方式可以連到雲端去執行服務
- the first option is direct connectivity (直連)
- the second option requires the on-premises data gateway to be installed (透過 gateway)

## Attended/Unattended desktop direct connectivity to the cloud service
<br><img src="https://docs.microsoft.com/zh-tw/power-automate/desktop-flows/media/pad-architecture/pad-direct-connectivity.png">

## Attended/Unattended desktop connectivity to the cloud service using the on-premises data gateway
<br><img src="https://docs.microsoft.com/zh-tw/power-automate/desktop-flows/media/pad-architecture/pad-on-premises-data-gateway.png">

## Session credential lifecycle
1. A desktop machine is registered by signing in to the on-premises data gateway or registering inside Power Automate Desktop using the **direct connectivity** feature. This process generates a public and private key to be used for secure communication with this machine.
    - 地端主機安裝 Power Automate Desktop，透過產生公、私鑰來進行加密連線
2. The machine registration request is sent by the desktop application to the Power Automate cloud services. The request contains the newly generated machine's **public key**. This key is stored along with the machine registration in the cloud.
    - 地端主機註冊的 request 會送去 Power Automate cloud 服務
    - 該 request 包含主機的公鑰，並會存在 cloud 內
3. When the request completes, the machine is successfully registered and appears in the Power Automate web portal as a resource that can be managed. However, the machine cannot be used by a flow until a connection to it is established.
    - 註冊完成，但還不行建立 data flow
4. To establish a Power Automate Desktop connection in the web portal, users must select an available machine and provide the username and password credentials of the account to use to run the desktop flow.
    - Users can select any previously registered machine, including machines that have been shared with them. When a connection is saved, the credentials are encrypted using the public key associated with the machine and stored in this encrypted form.
    - The cloud service is storing the encrypted user credentials for the machine. However, it can't decrypt the credentials because the private key only exists on the desktop machine. The user can delete this connection at any point, and the stored encrypted credentials will also be deleted.
        - 因為私鑰只存在地端主機，所以無法解密
5. When a desktop flow is run from the cloud, it uses a previously established connection selected in the Run a flow built with Power Automate Desktop action.
    - 當 data flow 在雲端執行時，會使用先前建立的連線去部署在 Power Automate Desktop
6. When the desktop flow job is sent from the cloud to the desktop, it includes the encrypted credentials stored in the connection. These credentials are then decrypted on the desktop using the secret private key, and they're used to sign in as the given user account.

Although the logical data flow is from the cloud to the desktop, the connection is established from the desktop to the cloud. It uses an Azure Relay to connect to the cloud using an outgoing web request.

If a gateway cluster is created using the on-premises data gateway, the private key used to decrypt credentials is generated on all machines in the cluster. The private key is generated using the recovery key that is requested during machine registration. The recovery key is never sent to the cloud.

If a machine group is created using direct connectivity, the group's private key is encrypted using a user-defined group password. Then, it's sent to the cloud for storage as part of the register machine request.

The encrypted private key is shared with other machines that join the group. However, as the user must first provide the password to decrypt this private key, the service can't read any stored credentials in the connection.

<br><img src="https://docs.microsoft.com/zh-tw/power-automate/desktop-flows/media/pad-architecture/pad-session-credential-lifecyle.png">

# [What is Azure Relay?](https://docs.microsoft.com/en-us/azure/azure-relay/relay-what-is-it)
The Azure Relay service enables you to securely expose services that run in your corporate network to the public cloud. You can do so without opening a port on your firewall, or making intrusive changes to your corporate network infrastructure.

# Reference
- [混合式 BI 服務架構～雲端 Power BI 服務整合地端資料服務平台架構](https://ithelp.ithome.com.tw/articles/10222898)
- [Power BI 开发 第六章：数据网管](https://www.cnblogs.com/ljhdo/p/5125235.html)

# 架構
<br><img src="https://docs.microsoft.com/zh-tw/power-bi/connect-data/media/service-gateway-onprem/on-premises-data-gateway.png">
<br><img src="https://ithelp.ithome.com.tw/upload/images/20190930/201201695mC63aj5Ta.png">