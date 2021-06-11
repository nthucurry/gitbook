# API Managerment
## API Management cross domain policies
### Cross domain policies
- Allow cross-domain calls - Makes the API accessible from Adobe Flash and Microsoft Silverlight browser-based clients.
- CORS - Adds cross-origin resource sharing (CORS) support to an operation or an API to allow cross-domain calls from browser-based clients.
- JSONP - Adds JSON with padding (JSONP) support to an operation or an API to allow cross-domain calls from JavaScript browser-based clients.

## IP addresses of API Management service in VNet
If your APIM service is inside a VNet, it will have two types of IP addresses - public and private.

Public IP addresses are **used for internal communication** on port 3443 - for managing configuration (for example, through Azure Resource Manager). In the external VNet configuration, they are also used for runtime API traffic. When a request is sent from API Management to a public-facing (Internet-facing) backend, a public IP address will be visible as the origin of the request.

Private virtual IP (VIP) addresses, available **only in the internal VNet** mode, are used to connect from within the network to API Management endpoints - gateways, the developer portal, and the management plane for direct API access. You can use them for setting up DNS records within the network.

## Integrate API Management in an internal VNet with Application Gateway
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