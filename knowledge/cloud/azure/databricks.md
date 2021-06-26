# Azure Databricks
Azure Databricks is a **data analytics** platform optimized for the Microsoft Azure cloud services platform. Azure Databricks offers two environments for developing data intensive applications: Azure Databricks SQL Analytics and Azure Databricks Workspace.
- network setting: https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html

# Azure Databricks SCIM Provisioning Connector
Azure Databricks SCIM Connector allows you to enable Users and Groups synchronization to a Databricks Workspace from AAD.
- Use Azure AD to manage user access, provision user accounts, and enable SSO with Azure Databricks SCIM Provisioning Connector. Requires an existing Azure Databricks SCIM Provisioning Connector subscription.

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