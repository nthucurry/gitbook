# API Managerment
## Self-hosted gateway overview

## API Management cross domain policies
### Cross domain policies
- Allow cross-domain calls - Makes the API accessible from Adobe Flash and Microsoft Silverlight browser-based clients.
- CORS - Adds cross-origin resource sharing (CORS) support to an operation or an API to allow cross-domain calls from browser-based clients.
- JSONP - Adds JSON with padding (JSONP) support to an operation or an API to allow cross-domain calls from JavaScript browser-based clients.

## IP addresses of API Management service in VNet
If your APIM service is inside a VNet, it will have two types of IP addresses - public and private.

Public IP addresses are **used for internal communication** on port 3443 - for managing configuration (for example, through Azure Resource Manager). In the external VNet configuration, they are also used for runtime API traffic. When a request is sent from API Management to a public-facing (Internet-facing) backend, a public IP address will be visible as the origin of the request.

Private virtual IP (VIP) addresses, available **only in the internal VNet** mode, are used to connect from within the network to API Management endpoints - gateways, the developer portal, and the management plane for direct API access. You can use them for setting up DNS records within the network.

## Connect to an internal VNet using Azure API Management
For configurations specific to the internal mode, where the developer portal and API gateway are accessible only within the VNet.

When API Management deploys in internal VNET mode, you can only view the following service endpoints within a VNET whose access you control.
- The proxy gateway
- The developer portal
- Direct management
- Git

Use API Management in internal mode to:
- Make APIs hosted in your private datacenter securely accessible by third parties, using site-to-site or Azure ExpressRoute VPN connections.
- Enable hybrid cloud scenarios by exposing your cloud-based APIs and on-premises APIs through a common - gateway.
- Manage your APIs hosted in multiple geographic locations, using a single gateway endpoint.

### Prerequisites
- An active Azure subscription.
- An Azure API Management instance.
- A Standard SKU public IPv4 address, if your client uses API version 2021-01-01-preview or later. The public IP address resource is required when setting up the virtual network for either external or internal access. With an **internal VNet**, the public IP address **is used only** for management operations.

## Integrate API Management in an internal VNet with Application Gateway
By combining API Management provisioned in an internal virtual network with the Application Gateway front end, you can:
- Use the same API Management resource for consumption by both **internal** consumers and **external** consumers.
- Use a single API Management resource and have a subset of APIs defined in API Management available for **external** consumers.
- Provide a turnkey way to switch access to API Management from the **public internet** on and off.

### Background
- 參考
    - https://www.jyt0532.com/2019/11/18/proxy-reverse-proxy
- Forward Proxy
    <br><img src="https://www.jyt0532.com/public/forward-proxy.png">
- Reverse Proxy
    <br><img src="https://www.jyt0532.com/public/reverse-proxy.png">

### Prerequisites
Certificates (憑證)
- pfx and cer for the API hostname
- pfx for the developer portal's hostname

### Scenario
<br><img src="https://docs.microsoft.com/en-us/azure/api-management/media/api-management-howto-integrate-internal-vnet-appgateway/api-management-howto-integrate-internal-vnet-appgateway.png">

### What is required to create an integration between API Management and Application Gateway?
- Back-end server pool
    - This is the **internal virtual IP address** of the API Management service.
- Back-end server pool settings
    - Every pool has settings like port, protocol, and cookie-based affinity. These settings are applied to all servers within the pool.
- Front-end port
    - This is the public port that is opened on the application gateway. Traffic hitting it gets redirected to one of the back-end servers.
- Listener
    -The listener has a front-end port, a protocol (Http or Https, these values are case-sensitive), and the TLS/SSL certificate name (if configuring TLS offload).
- Rule
    - The rule binds a listener to a back-end server pool.
- Custom Health Probe
    - Application Gateway, by default, uses IP address based probes to figure out which servers in the BackendAddressPool are active. The API Management service only responds to requests with the correct host header, hence the default probes fail. A custom health probe needs to be defined to help application gateway determine that the service is alive and it should forward requests.
- Custom domain certificates
    - To access API Management from the internet, you need to create a CNAME mapping of its hostname to the Application Gateway front-end DNS name. This ensures that the hostname header and certificate sent to Application Gateway that is forwarded to API Management is one APIM can recognize as valid. In this example, we will use two certificates - for the backend and for the developer portal.

## Step
1. Create a resource group for Resource Manager
2. Create a VNet and a subnet for the application gateway
3. Create an APIM service inside a VNet configured in internal mode
4. Set up custom domain names in API Management
    - Initialize the following variables with the details of the certificates with private keys for the domains and the trusted root certificate.
        - In this example, we use api.contoso.net, portal.contoso.net, and management.contoso.net.
    - Create and set the hostname configuration objects for the API Management endpoints.
5. Configure a private zone for DNS resolution in the VNet
    - Create a private DNS zone and link the virtual network.
    - Create A-records for the custom domain hostnames, mapping to the private IP address of the API Management service
6. Create a public IP address for the front-end configuration
    - Create a Standard public IP resource **publicIP01** in the resource group.
    - An IP address is assigned to the application gateway when the service starts.
7. Create application gateway configuration
    - All configuration items must be set up **before creating the application gateway**. The following steps create the configuration items that are needed for an application gateway resource.
8. Create Application Gateway
9. CNAME the API Management proxy hostname to the public DNS name of the Application Gateway resource

## Troubleshooting
- Failed to connect to management endpoint at t-apim-external.management.azure-api.net:3443 for a service deployed in a virtual network. Make sure to follow guidance at https://aka.ms/apim-vnet-common-issues.
    - NSG 新增 APIM service tag to VNet