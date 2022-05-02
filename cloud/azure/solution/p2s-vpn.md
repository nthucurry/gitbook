# Price
- [VPN Gateway pricing](https://azure.microsoft.com/en-us/pricing/details/vpn-gateway/#pricing)

# Scenario
When you connect to your VNet using Azure VPN Gateway P2S, you have a choice of which protocol to use. The protocol you use determines the authentication options that are available to you. If you want to use AAD authentication, you can do so when using the OpenVPN protocol. This article helps you set up an AAD tenant.
- [Create an Azure AD tenant for P2S OpenVPN protocol connections](https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant)
    - AAD authentication is supported for [OpenVPN](https://zh.wikipedia.org/wiki/OpenVPN) protocol connections only and requires the Azure VPN client.
    - The Basic SKU is not supported for OpenVPN.
- [Configure a VPN client for P2S OpenVPN protocol connections - Azure AD authentication - macOS](https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-client-mac)