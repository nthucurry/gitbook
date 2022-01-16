# Private Link
<br><img src="https://docs.microsoft.com/en-us/azure/private-link/media/private-link-service-overview/consumer-provider-endpoint.png">

# Private Endpoint
Private endpoint enables connectivity between the consumers from the same:
- Virtual Network
- Regionally peered virtual networks
- Globally peered virtual networks
- On premises using VPN or Express Route
- Services powered by Private Link

## Network security of private endpoints
When using private endpoints, **traffic is secured** to a private link resource. The platform does an access control to validate network connections reaching only the specified private link resource.

## Network Security Group rules for subnets with private endpoints
Currently, you **can't** configure NSG rules and user-defined routes for private endpoints. NSG rules applied to the subnet hosting the private endpoint are not applied to the private endpoint.

# Azure Private Endpoint DNS configuration
- Use the host file (only recommended for testing).
- Use a private DNS zone.
- Use your DNS forwarder (optional).

# Service Endpoint
<br>
<img src="https://sameeraman.files.wordpress.com/2019/11/clip_image001-1.png" width=500>
<br>
<img src="https://docs.microsoft.com/en-us/learn/modules/secure-and-isolate-with-nsg-and-service-endpoints/media/4-service-endpoint-flow.svg" width=500>
<img src="https://docs.microsoft.com/en-us/learn/modules/secure-and-isolate-with-nsg-and-service-endpoints/media/5-exercise-task.svg" width=500>