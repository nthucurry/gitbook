# Goal
- User 是自己專案 Admin
- User 是 AST 專案使用者
- User 只能看到自己的專案 pipeline
- User commit 後，可以自動在 AST 專案執行 pipeline

# Service Connections
- User permissions
    - [ ] Creator: Members of this role can **create** the service connection in the project. **Contributors** are added as members by default.
    - [ ] Reader: Members of this role can **view** the service connection.
    - [x] User: Members of this role can **use** the service connection when authoring build or release pipelines or authorize yaml pipelines.
    - [ ] Administrator: Members of this role can use the service connection and manage membership of all other roles for the project's service connection. **Project Administrators** are added as members by default.
- [Pipeline permissions](https://docs.microsoft.com/zh-tw/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#pipeline-permissions)
- [Project permissions - Cross project sharing of service connections](https://docs.microsoft.com/zh-tw/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#project-permissions---cross-project-sharing-of-service-connections)

# Pipeline Permissions
- Pipeline permissions are the permissions **associated with** pipelines in an Azure DevOps project.
- [Pipeline permissions](https://docs.microsoft.com/en-us/azure/devops/pipelines/policies/permissions?source=recommendations&view=azure-devops#pipeline-permissions-reference)

# Configure security & settings
- [Add users to Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/policies/set-permissions?view=azure-devops)
- [Secure access to Azure Repos from pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/security/secure-access-to-repos?view=azure-devops&tabs=yaml)