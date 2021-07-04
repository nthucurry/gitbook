# Services Access Different Parts
| Scenario  | Workspace        | Associated resources                             | Training compute environment | Inferencing compute environment |
|-----------|------------------|--------------------------------------------------|------------------------------|---------------------------------|
| No VNet   | Public IP        | Public IP                                        | Public IP                    | Public IP                       |
| In a VNet | Private Endpoint | Public IP (Service Endpoint) or Private Endpoint | Private IP                   | Private IP                      |

# Optional: Enable public access
You can secure the workspace behind a VNet **using a private endpoint** and still allow access over the public internet. The initial configuration is the same as securing the workspace and associated resources.
After securing the workspace with a private link, you then Enable public access. After this, you can access the workspace from both the public internet and the VNet.

## Limitations
If you use Azure Machine Learning studio over the public internet, some features such as the designer **may fail to access** your data. This problem happens when the data is stored on a service that is secured behind the VNet. For example, an Azure Storage Account.

# What is Azure Container Instances? (窮人版 AKS)
Containers are becoming the preferred way to package, deploy, and manage cloud applications. ACI offers the fastest and simplest way to run a container in Azure, without having to manage any VMs and without having to adopt (採納) a higher-level service.

# Deploy a model to Azure Container Instances
- prefer not to manage your own K8S cluster
- Are OK with having only a single replica of your service, which may impact uptime

# Enable Azure Container Instances (ACI)
ACI are dynamically created when deploying a model. To enable Azure Machine Learning to create ACI inside the VNet, you must enable subnet delegation for the subnet used by the deployment.