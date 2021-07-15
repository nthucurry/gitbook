- [Enterprise applications](#enterprise-applications)
- [Azure DevOps](#azure-devops)
- [Azure Machine Learning](#azure-machine-learning)
    - [Virtual network isolation and privacy overview](#virtual-network-isolation-and-privacy-overview)
    - [Secure an Azure Machine Learning inferencing environment with virtual networks](#secure-an-azure-machine-learning-inferencing-environment-with-virtual-networks)
- [Lab Service](#lab-service)
- [Service Principal](#service-principal)

# Enterprise applications
AAD is an IAM system. It provides a single place to store information about digital identities. You can configure your software applications to use Azure AD as the place where user information is stored.

AAD must be configured to integrate with an application. In other words, it needs to know what apps are using it for identities (身份). Making AAD aware of these apps, and how it should handle them, is known as application management.
<br><img src="https://docs.microsoft.com/zh-tw/azure/active-directory/manage-apps/media/what-is-application-management/app-management-overview.png">

# Azure DevOps
Plan smarter, collaborate better, and ship faster with a set of modern (現代化) dev services.
- Azure Boards
- Azure Pipelines
    <br>Build, test, and deploy with **CI/CD** that works with any language, platform, and cloud. Connect to GitHub or any other Git provider and deploy continuously.
- Azure Repos
- Azure Test Plans
- Azure Artifacts

# Azure Machine Learning
## Virtual network isolation and privacy overview
<br><img src="https://docs.microsoft.com/en-us/azure/machine-learning/media/how-to-network-security-overview/secure-workspace-resources.png">

## Secure an Azure Machine Learning inferencing environment with virtual networks
<br><img src="https://docs.microsoft.com/en-us/azure/machine-learning/media/how-to-network-security-overview/secure-inferencing-environment.png">

# Lab Service
- [雲端中的電腦教室 Azure Lab Services](https://reurl.cc/DgDgXe)

# Service Principal
```bash
az ad sp create-for-rbac --skip-assignment --name openaigpupocsp
```