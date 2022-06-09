# [Configure App Service with Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/configure-web-app?tabs=customdomain%2Cazure-portal)
The configuration for Application Gateway will differ depending on how App Service will be accessed:
- Custom domain (recommended)
    <br><img src="https://docs.microsoft.com/en-us/azure/application-gateway/media/configure-web-app/scenario-application-gateway-to-azure-app-service-custom-domain.png" board="1">
- Default domain
    <br><img src="https://docs.microsoft.com/en-us/azure/application-gateway/media/configure-web-app/scenario-application-gateway-to-azure-app-service-default-domain.png" board="1">

## 1. Prerequisites
A custom domain name and associated certificate (signed by a well known authority), stored in Key Vault.

## 2. Configuring DNS
Route the user or client to Application Gateway using the custom domain. Set up DNS using a CNAME alias pointed to the DNS for Application Gateway. The Application Gateway DNS address is shown on the overview page of the associated Public IP address. Alternatively create an A record pointing to the IP address directly. (For Application Gateway V1 the VIP can change if you stop and start the service, which makes this option undesired.)

- App Service
    - should be configured so it accepts traffic from Application Gateway using the custom domain name as the incoming host.
    - For more information on how to map a custom domain to the App Service, see [Tutorial: Map an existing custom DNS name to Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain?tabs=a%2Cazurecli)
        - Get a domain verification ID
    - To verify the domain, App Service only requires adding a TXT record. No change is required on CNAME or A-records. The DNS configuration for the custom domain will remain directed towards Application Gateway.

To accept connections to App Service over HTTPS, configure its TLS binding. For more information, see Secure a custom DNS name with a TLS/SSL binding in Azure App Service Configure App Service to pull the certificate for the custom domain from Azure Key Vault.

## 3. Add App service as backend pool

## 4. Edit HTTP settings for App Service

## 5. Configure an HTTP listener

## 6. Configure request routing rule