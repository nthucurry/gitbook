# Azure Function
## Logic Apps
Azure Logic Apps is a cloud service that helps you **schedule**, **automate**, and **orchestrate** (編排) **tasks**, **business processes**, and **workflows** when you need to integrate apps, data, systems, and services across enterprises or organizations.

Logic Apps simplifies how you design and build scalable solutions for app integration, data integration, system integration, enterprise application integration (EAI), and business-to-business (B2B) communication, whether in the cloud, on premises, or both.

### Why use Logic Apps
- Visually create and edit workflows with **easy-to-use** tools
- Connect different systems across various environments
- Write once, reuse often
- First-class support for enterprise integration and B2B scenarios
- Built-in extensibility
- Access resources inside VNet
    <br>Logic app workflows can access secured resources, such as VMs and other systems or services, that are inside an VNet when you create an integration service environment (ISE).
- Pricing options

<img src="https://biztalk360.com/wp-content/uploads/2016/12/Use-case-scenario.png">

## API Management (API Proxy)
API Management (APIM) is a way to create consistent and modern API gateways for existing back-end services.

API Management helps organizations publish APIs to external, partner, and internal developers to unlock the potential of their data and services. Businesses everywhere are looking to extend their operations as a digital platform, creating new channels, finding new customers and driving deeper engagement with existing ones. API Management provides the core competencies (管理能力) to ensure a successful API program through developer engagement (保證), business insights, analytics, security, and protection. You can use Azure API Management to take any backend and launch a full-fledged API program based on it.

若要用最簡單的方式來介紹 API Management，基本上他就是一個 API Proxy，每一個 API Management 服務都提供了一個「https://*.portal.azure-api.net/」端點讓您呼叫自己的 API，主要的應用情境筆者理解如下：
- 匯集各方的 API 到同一個 endpoint：假設產品所需要用到的 API 是來自各個第三方的 endpoint，透過 API Management 可以整到同一個端點底下來方便管理，若有端點的更新也可以直接從 Portal 抽換更新。
- 提供自己服務的 API 讓其他客戶使用：假如公司的服務規模大到提供 API、SDK 來讓第三方使用，這時可能會有不同等級的區分，例如可能依照價格來控制每秒或每分鐘可以請求的流量，或是依照不同的服務等級有不同的 API 可以使用，這時便可以透過 API Management 來統一管理，減少原始 API 所需要做的變動。

<br><img src="https://docs.microsoft.com/en-us/azure/api-management/media/api-management-using-with-vnet/api-management-vnet-internal.png">

## Integration Service Environments (ISE)
ISE is a fully isolated and dedicated environment for all enterprise-scale integration needs. When you create a new ISE, it’s injected into your VNet allowing you to deploy **Logic Apps** as a service in your VNet.

## JIRA SAML SSO by Microsoft
- https://docs.microsoft.com/zh-tw/azure/active-directory/saas-apps/jiramicrosoft-tutorial

### Security Assertion Markup Language (SAML)
安全宣告標記語言 (SAML) 是一種 XML 標準，可讓安全的網域互相交換使用者驗證與使用者授權資料。線上服務供應商可以使用 SAML 與個別線上識別資訊提供者聯絡，對嘗試存取安全內容的使用者加以驗證。
<br><img src="https://docs.microsoft.com/zh-tw/azure/active-directory/develop/media/single-sign-on-saml-protocol/active-directory-saml-single-sign-on-workflow.png">
<br><img src="https://lh3.googleusercontent.com/ijxXNNLYFPLlMEjBf5yWS2xRiLDRRXUcYyX8mY61dPa1wfxpWExmdMazM7kEWWVjf6s=w661">

### Active Directory Federation Services (ADFS)
識別身分同盟的組織也就是 Active Directory Federation Services (ADFS) 是一種可以讓特定 Active Directory (AD) 加入的服務。一旦任何的 AD 加入了這個同盟組織，ADFS 伺服器可以立刻的知道。而這樣的特性剛好可以跟單一認證系統 SSO 做互相的整合與應用，讓之後陸續加入的 AD (或跨網域 AD) 可以做為單一認證系統 SSO 的諮詢對象，進而逹到跨網域的控管。

### Multi-Factor Authentication
Multi-factor authentication is a process where a user is prompted during the sign-in process for an additional form of identification, such as to enter a code on their cellphone or to provide a fingerprint scan.

先決條件
- A working AAD tenant with at least an **AAD Premium P1** or trial license enabled.
- An account with **global administrator** privileges.
- A non-administrator user with a password you know, such as testuser.
- A group that the non-administrator user is a member of, such as MFA-Test-Group. You enable **AAD** Multi-Factor Authentication for this group in this tutorial.

### Proxy
https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/tenant-restrictions#testing
```csharp
// Allows access to the listed tenants.
if (
    oSession.HostnameIs("login.microsoftonline.com") ||
    oSession.HostnameIs("login.microsoft.com") ||
    oSession.HostnameIs("login.windows.net")
    )
{
    oSession.oRequest["Restrict-Access-To-Tenants"] = "<primary domain>.onmicrosoft.com";
    oSession.oRequest["Restrict-Access-Context"] = "<tenant ID>";
}

// Blocks access to consumer apps
if (
    oSession.HostnameIs("login.live.com")
    )
{
    oSession.oRequest["sec-Restrict-Tenant-Access-Policy"] = "restrict-msa";
}
```