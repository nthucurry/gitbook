function FindProxyForURL(url, host) {
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
        return "PROXY 10.0.8.4:3128";
    else
        // DEFAULT RULE: All other traffic, send direct
        return "PROXY 10.0.8.13:3128";
}