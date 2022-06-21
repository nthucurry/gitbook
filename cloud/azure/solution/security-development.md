# Target
- Internet 和公司內可以使用
- Source Code 上傳至雲端
- User 到源碼環境掃 Code

# 預計 Scenario
1. 登入 Azure DevOps Portal
2. 上傳 Code
3. 登入 WVD
4. 執行白箱掃描

# Azure Virtual Desktop (WVD)
- 授權
    - Microsoft 365 E3, E5, A3, A5, F1, Business 或 Windows E3, E5, A3, A5 上述任一種授權
    - [Operating systems and licenses](https://docs.microsoft.com/en-us/azure/virtual-desktop/prerequisites#operating-systems-and-licenses)
- 架構
    - [acer](https://www.aceraeb.com/mainssl/modules/MySpace/BlogInfo.php?xmlid=1506)
        <br><img src="https://comet.noonspace.com/w72NoonSpace/acer/MsgInfo/wvd22.PNG">
    - [華致資訊](https://www.infofab.com/microsoft.html)
        <br><img src="http://www.infofab.com/images/WVD02.JPG">
- [Remote Desktop clients](https://docs.microsoft.com/en-us/azure/virtual-desktop/prerequisites#remote-desktop-clients)
- [For subscriptions without Azure AD DS or AD DS](https://docs.microsoft.com/en-us/azure/virtual-desktop/getting-started-feature#for-subscriptions-without-azure-ad-ds-or-ad-ds)
- [Supported identity scenarios](https://docs.microsoft.com/en-us/azure/virtual-desktop/prerequisites#supported-identity-scenarios)

    | Identity scenario              | Session hosts         | User accounts                             |
    |--------------------------------|-----------------------|-------------------------------------------|
    | Azure AD + AD DS               | Joined to AD DS       | In AD DS and Azure AD, synchronized       |
    | Azure AD + Azure AD DS         | Joined to Azure AD DS | In Azure AD and Azure AD DS, synchronized |
    | Azure AD + Azure AD DS + AD DS | Joined to Azure AD DS | In Azure AD and AD DS, synchronized       |
    | **Azure AD only**                  | Joined to Azure AD    | In Azure AD                               |

# Azure DevOps
- User Price
- Self-hosted Linux agents

# AAD
- Conditional Access
- Tenant Restriction

# 白箱環境