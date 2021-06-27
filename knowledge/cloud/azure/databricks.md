- [Introduction](#introduction)
- [Azure Databricks SCIM Provisioning Connector](#azure-databricks-scim-provisioning-connector)
- [Security Guide](#security-guide)
    - [Access control](#access-control)
    - [IP access lists](#ip-access-lists)
- [Deploy Azure Databricks in your Azure virtual network (VNet injection)](#deploy-azure-databricks-in-your-azure-virtual-network-vnet-injection)
- [Secure cluster connectivity (No Public IP / NPIP)](#secure-cluster-connectivity-no-public-ip--npip)
- [User-defined route settings for Azure Databricks](#user-defined-route-settings-for-azure-databricks)
    - [Control plane NAT, webapp, and extended infrastructure IP addresses](#control-plane-nat-webapp-and-extended-infrastructure-ip-addresses)
    - [DBFS root Blob storage IP address](#dbfs-root-blob-storage-ip-address)
    - [Metastore, artifact Blob storage, log Blob storage, and Event Hub endpoint IP addresses](#metastore-artifact-blob-storage-log-blob-storage-and-event-hub-endpoint-ip-addresses)

# Introduction
Azure Databricks is a **data analytics** platform optimized for the Microsoft Azure cloud services platform. Azure Databricks offers two environments for developing data intensive applications: Azure Databricks SQL Analytics and Azure Databricks Workspace.
- network setting: https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html

# Azure Databricks SCIM Provisioning Connector
Azure Databricks SCIM Connector allows you to enable Users and Groups synchronization to a Databricks Workspace from AAD.
- Use Azure AD to manage user access, provision user accounts, and enable SSO with Azure Databricks SCIM Provisioning Connector. Requires an existing Azure Databricks SCIM Provisioning Connector subscription.

# Security Guide
## Access control
## IP access lists
<br><img src="https://docs.microsoft.com/en-us/azure/databricks/_static/images/security/network/ip-access-lists-azure.png">

# Deploy Azure Databricks in your Azure virtual network (VNet injection)
The VNet must include two subnets dedicated to your Azure Databricks workspace:
- a container subnet (sometimes called the private subnet)
- a host subnet (sometimes called the public subnet)

However, for a workspace that uses **secure cluster connectivity**, both the container subnet and host subnet are private.

# Secure cluster connectivity (No Public IP / NPIP)
With secure cluster connectivity enabled, customer VNet have no open ports and Databricks Runtime cluster nodes have no public IP addresses. Secure cluster connectivity is also known as No Public IP (NPIP).

To use secure cluster connectivity with a new Azure Databricks workspace, use any of the following options.
- Azure Portal: When you provision the workspace, go to the Networking tab and set the option Deploy Azure Databricks workspace with Secure Cluster Connectivity (No Public IP) to Yes.
- ARM Templates: For the Microsoft.Databricks/workspaces resource that creates your new workspace, set the enableNoPublicIp Boolean parameter to true.

# User-defined route settings for Azure Databricks
If your Azure Databricks workspace is deployed to your own VNet, you can use custom routes, also known as user-defined routes (UDR), to ensure that network traffic is routed correctly for your workspace.

For example, if you connect the virtual network to your on-premises network, traffic may be routed through the on-premises network and **unable to reach** the Azure Databricks control plane. User-defined routes can solve that problem.

You need a UDR for every type of outbound connection from the VNet. The details vary based on whether secure cluster connectivity (SCC) is enabled for the workspace:
- If SCC is enabled for the workspace, you need a UDR to allow the clusters to connect to the SCC relay (傳送) in the control plane. Be sure to include the systems marked as SCC relay IP for your region.
- If SCC is disabled for the workspace, there is an inbound connection from the Control Plane NAT, but the low-level TCP SYN-ACK to that connection technically is outbound data that requires a UDR. Be sure to include the systems marked as Control Plane NAT IP for your region.

## Control plane NAT, webapp, and extended infrastructure IP addresses
| Source  | Address prefix                                 | Next hop type |
|---------|------------------------------------------------|---------------|
| Default | Control plane NAT IP (Only if SCC is disabled) | Internet      |
| Default | SCC relay IP (Only if SCC is enabled)          | Internet      |
| Default | Webapp IP                                      | Internet      |
| Default | Extended infrastructure IP                     | Internet      |
| Default | Metastore IP                                   | Internet      |
| Default | Artifact Blob storage IP                       | Internet      |
| Default | Log Blob storage IP                            | Internet      |
| Default | DBFS root Blob storage IP                      | Internet      |

## DBFS root Blob storage IP address
The domain name is in the format dbstorage\*\*\*\*\*\*\*\*\*\*\*blob.core.windows.net.

## Metastore, artifact Blob storage, log Blob storage, and Event Hub endpoint IP addresses
To get the metastore, artifact Blob storage, log Blob storage, and Event Hub IP addresses, you must use their domain names, provided in the following table, to **look up** the IP addresses.