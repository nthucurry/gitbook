# Azure Monitor
| source ip | target ip                            | target port |
|-----------|--------------------------------------|-------------|
| VNet      | dc.applicationinsights.azure.com     | 443         |
| VNet      | dc.applicationinsights.microsoft.com | 443         |
| VNet      | dc.services.visualstudio.com         | 443         |
| VNet      | *.in.applicationinsights.azure.com   | 443         |
| VNet      | live.applicationinsights.azure.com   | 443         |
| VNet      | rt.applicationinsights.microsoft.com | 443         |
| VNet      | rt.services.visualstudio.com         | 443         |

# AML
| source ip            | target ip                                    | target port |
|----------------------|----------------------------------------------|-------------|
| AzureMachineLearning | VNet                                         | 44224       |
| BatchNodeManagement  | VNet                                         | 29876-29877 |
| VNet                 | AzureMonitor                                 | 443         |
| VNet                 | AzureActiveDirectory                         | 443         |
| VNet                 | AzureMachineLearning                         | 443         |
| VNet                 | AzureResourceManager                         | 443         |
| VNet                 | Storage.region                               | 443         |
| VNet                 | ContainerRegistry.region                     | 443         |
| VNet                 | MicrosoftContainerRegistry.region            | 443         |
| VNet                 | Keyvault.region                              | 443         |
| VNet                 | graph.windows.net                            | 443         |
| VNet                 | anaconda.com, *.anaconda.com, *.anaconda.org | 443         |
| VNet                 | pypi.org                                     | 443         |
| VNet                 | cloud.r-project.org                          | 443         |
| VNet                 | *.pytorch.org                                | 443         |
| VNet                 | *.tensorflow.org                             | 443         |
| VNet                 | update.code.visualstudio.com                 | 443         |
| VNet                 | *.vo.msecnd.net                              | 443         |
| VNet                 | raw.githubusercontent.com                    | 443         |
| VNet                 | cloud.r-project.org                          | 443         |
| VNet                 | dc.applicationinsights.azure.com             | 443         |
| VNet                 | dc.applicationinsights.microsoft.com         | 443         |
| VNet                 | dc.services.visualstudio.com                 | 443         |

# Databricks
| source ip | target ip       | target port |
|-----------|-----------------|-------------|
| VNet      | AzureDatabricks | 443         |
| VNet      | SQL             | 3306        |
| VNet      | Storage         | 443         |
| VNet      | EventHub        | 9093        |