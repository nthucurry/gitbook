# Machine Learning
## What is Azure Container Instances? (窮人版 AKS)
Containers are becoming the preferred way to package, deploy, and manage cloud applications. ACI offers the fastest and simplest way to run a container in Azure, without having to manage any VMs and without having to adopt (採納) a higher-level service.

## Deploy a model to Azure Container Instances
- prefer not to manage your own K8S cluster
- Are OK with having only a single replica of your service, which may impact uptime

### Limitations
- When using ACI in a VNet, the VNet must be in the **same resource group** as your Azure Machine Learning workspace.
- When using ACI inside the VNet, the Azure Container Registry (ACR) for your workspace cannot also be in the virtual network.

## Enable Azure Container Instances (ACI)
ACI are dynamically created when deploying a model. To enable Azure Machine Learning to create ACI inside the VNet, you must enable subnet delegation for the subnet used by the deployment.