function FindProxyForURL(url, host) {
    // Normalize the URL for pattern matching
    var url = url.toLowerCase();
    var host = host.toLowerCase();
    if (
        (dnsDomainIs(host, "portal.azure.com")) ||
        (host == "protal.azure.com") ||
        (host == "login.microsoftonline.com") ||
        (host == "login.microsoft.com") ||
        (host == "login.windows.net")
    )
        // If the hostname matches, send to the proxy
        return "PROXY 10.248.15.8:3128";
    else
        // DEFAULT RULE: All other traffic, send direct
        return "DIRECT";
}