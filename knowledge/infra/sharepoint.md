# SharePoint
## Install SOP
### Preinstall
- 遇到 Windows Server AppFabric is not correctly configured.You Should uninstall Windows Server Appfabric and reinstall it using The SharePoint Products Preparation Tool 問題
    - 依序執行就好
    - https://spgeeks.devoworx.com/windows-server-appfabric-is-not-correctly-configured-as-sharepoint-2013-prerequisites/
- [prerequisiteinstaller.exe](https://docs.microsoft.com/en-us/SharePoint/install/hardware-and-software-requirements#prerequisite-installer-operations-and-command-line-options)
- [https://social.technet.microsoft.com/Forums/security/en-US/e0e19a7d-861a-4ae4-8ac1-dfb3c53f57e8/sharepoint-2016-standard-product-key?forum=SP2016](https://social.technet.microsoft.com/Forums/security/en-US/e0e19a7d-861a-4ae4-8ac1-dfb3c53f57e8/sharepoint-2016-standard-product-key?forum=SP2016)
- overall
    ```
    Web Server (IIS) Role: add role (include dotNET 3.5)
    Microsoft SQL Server 2012 Native Client: 直接下載安裝
    Microsoft ODBC Driver 11 for SQL Server: 直接下載安裝
    Microsoft Sync Framework Runtime v1.0 SP1 (x64): 直接下載安裝
    Windows Server AppFabric: **可參考上面問題處理方式**
    Microsoft Identity Extensions: Windows 2016 需安裝 dotNET 3.5 (如果沒網路用 Win 2016 ISO 指定 dotNET 路徑)
    Microsoft Information Protection and Control Client 2.1: 直接下載安裝
    Microsoft WCF Data Services 5.6: 直接下載安裝
    Cumulative Update Package 7 for Microsoft AppFabric 1.1 for Windows Server (KB3092423): 直接下載安裝
    Microsoft .NET Framework 4.6: add role (include dotNET 3.5)
    Visual C++ Redistributable Package for Visual Studio 2012: 直接下載安裝
    Visual C++ Redistributable Package for Visual Studio 2015: 直接下載安裝
    ```

### SharePoint Configuration Wizard
- 遇到 error 時
    - https://techcommunity.microsoft.com/t5/sharepoint-support-blog/sharepoint-fails-to-create-configuration-database-for-a-new-farm/ba-p/309056
    - 依上述步驟調整後，重新安裝 WCF 5.6
    - https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn265982(v=ws.11)

## SharePoint Setting after install
### Mail
- [設定 SMTP 服務](https://docs.microsoft.com/zh-tw/sharepoint/administration/incoming-email-configuration#to-configure-the-smtp-service)
- 測試外送郵件
    - telnet au3mr1 25
        ```
        EHLO au3mr1
        MAIL FROM:SharePoint2016@gmail.com
        RCPT TO:xxxx@gmail.com
        DATA
        SUBJECT: mail server text!
        Test!!
        .
        quit
        ```
- Email account setting
    - [Configuring Incoming Email on a SharePoint 2013 Document Library](https://www.youtube.com/watch?v=mHLPZzJ15iU)

### WorkFlow
- debug: Type System.CodeDom.CodeBinaryOperatorExpression is not marked as authorized in the application configuration file.
    - https://spandcrm.com/2018/10/11/sharepoint-2013-workflows-failing-with-failed-to-start-error/
- 新增 web.config: C:\inetpub\wwwroot\wss\VirtualDirectories\80
    ```xml
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodeBinaryOperatorExpression" Authorized="True" />
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodePrimitiveExpression" Authorized="True" />
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodeMethodInvokeExpression" Authorized="True" />
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodeMethodReferenceExpression" Authorized="True" />
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodeFieldReferenceExpression" Authorized="True" />
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodeThisReferenceExpression" Authorized="True" />
    <authorizedType Assembly="System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" NameSpace="System.CodeDom" TypeName="CodePropertyReferenceExpression" Authorized="True" />
    ```
- 建立工作流程
    ![](../../file/img/learning/moss/moss-designer-setting-1.png)
- 內容
    ```
    Hi [%目前項目:指定給%]
    [%目前項目:建立者%]指派此報修給您
    Task
    Thanks
    ```

### Else issue
- Dynamic Filters: today and me
    - https://sharepoint.stackexchange.com/questions/179759/looking-for-a-list-of-available-column-filter-commands-me-today-etc
- View 特色
    - https://sharepoint.stackexchange.com/questions/134959/query-standard-view-with-expanded-recurring-events-doesnt-show-all-items
    - Standard View (只能看**非**週期性事件)
    - Standard View, with Expanded Recurring Events (只能看週期性事件)
    - All Events (看所有事件，但是週期性因為時間關係，會怪怪的)
- DB schema
    - dbo.SchedSubscriptions
- 計算欄位
    - 公式: `=IF(OR(AND(會議狀況="有 Issue",[Issue 狀態]="Open"),AND(會議狀況="有 Issue",[Issue 狀態]="-"),AND(會議狀況="-",[Issue 狀態]="-")),TRUE,FALSE)`