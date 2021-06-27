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