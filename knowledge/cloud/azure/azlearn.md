# Azure Learn Lesson
- https://github.com/MicrosoftLearning
    - 104
        - https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/
        - https://github.com/MicrosoftLearning/Lab-Demo-Recordings/blob/master/AZ-104.md

## EDA David POC
- 跨 subscription 的 resource migration
- NSG 設定權責?
- 控制 subscription 最高權限 -- Daivd
- assign policy
    - Not allowed resource types
        1. microsoft.network/virtualnetworks
        2. microsoft.network/networksecuritygroups
    - Allowed locations
        1. southeastasia
    - 注意 policy 連最高的 owner 都會被管理到，所以需要視情況放行，完事後再啟動 policy
- IAM
    - 用這個來控制 end-user 權限
    - deny 讀寫，read 視情況
    ```json
    "permissions": [
        {
            "actions": [
                "*"
            ],
            "notActions": [
                "Microsoft.Authorization/elevateAccess/action",
                "Microsoft.Authorization/classicAdministrators/write",
                "Microsoft.Authorization/classicAdministrators/delete",
                "Microsoft.Authorization/classicAdministrators/operationstatuses/read",
                "Microsoft.Authorization/denyAssignments/write",
                "Microsoft.Authorization/denyAssignments/delete",
                "Microsoft.Authorization/policyAssignments/write",
                "Microsoft.Authorization/policyAssignments/delete",
                "Microsoft.Authorization/policyAssignments/exempt/action",
                "Microsoft.Authorization/policyAssignments/privateLinkAssociations/write",
                "Microsoft.Authorization/policyAssignments/privateLinkAssociations/delete",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/write",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/delete",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnections/write",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnections/delete",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/write",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/delete",
                "Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/validate/action",
                "Microsoft.Authorization/policyDefinitions/write",
                "Microsoft.Authorization/policyDefinitions/delete",
                "Microsoft.Authorization/policies/audit/action",
                "Microsoft.Authorization/policies/auditIfNotExists/action",
                "Microsoft.Authorization/policies/deny/action",
                "Microsoft.Authorization/policies/deployIfNotExists/action",
                "Microsoft.Authorization/policyExemptions/write",
                "Microsoft.Authorization/policyExemptions/delete",
                "Microsoft.Authorization/policySetDefinitions/write",
                "Microsoft.Authorization/policySetDefinitions/delete",
                "Microsoft.Authorization/roleAssignments/write",
                "Microsoft.Authorization/roleAssignments/delete",
                "Microsoft.Authorization/roleDefinitions/write",
                "Microsoft.Authorization/roleDefinitions/delete",
                "Microsoft.Network/networkSecurityGroups/write",
                "Microsoft.Network/networkSecurityGroups/delete",
                "Microsoft.Network/networkSecurityGroups/securityRules/write",
                "Microsoft.Network/networkSecurityGroups/securityRules/delete"
            ],
            "dataActions": [],
            "notDataActions": []
        }
    ]
    ```
    - Microsoft.Network/azurefirewalls
    - Microsoft.Network/applicationGateways
- SOP
    1. 建立 resource group
    2. 建立 policy
    3. 建立 NSG

## Policy
- https://github.com/Azure/azure-policy
- NSG, subscription, resource group
- resource types: 僅能建立特定 IaaS, PaaS, SaaS
    <img src="../../../img/cloud/azure/iam-network-sample.png" width=700><br>
- VM SKUs: 指定規格
- location
- tag
    - 必使用 tag 才能建立資源
        - service type: DB, AP...
    - 繼承 tag
- backup

## Allowed locations(指定區域)
Home --> Policy --> Assign policy --> Parameters --> Allowed locations

## Group
- dynamic group: 可依據條件來設定群組，例如 job title = XXX
- 在同一個 AAD 下，可跨 subscription 做管理

## Tag
- 管理不同 location、不同 resource group 的資源
    - IaaS: VM
    - PaaS: SQL database
- 同個 resource group，下 tag 沒辦法帶到子目錄去，除非
    - 寫程式
    - azure policy

## Role-Based Access Control (RBAC)
RBAC helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to.
- 委派三元素: 範圍、角色、誰
- 產出 json file
    ```powershell
    Get-AzRoleDefinition -name reader | convertto-json
    ```

## Resource
- 同個 AAD 之下， resource 可跨 subscription or other resource group 移動
- 跨 subscription 移動時，要注意目的端有沒有相對應的 resource type register

## Template
https://github.com/Azure/azure-quickstart-templates

## Migrate to another subscription
<img src="../../../img/cloud/azure/migratie-to-new-subscription.png" width=700><br>
https://medium.com/@calloncampbell/moving-your-azure-resources-to-another-subscription-or-resource-group-1644f43d2e07