function FindProxyForURL(url, host) {
    var url = url.toLowerCase();
    var host = host.toLowerCase();
    if (
        (dnsDomainIs(host, "login.microsoftonline.com")) ||
        (host == "login.microsoft.com") ||
        (host == "login.windows.net")
    )
        return "PROXY 10.0.8.4:3128";
    else if (
        isInNet(host, "10.0.0.0", "255.255.0.0")
    )
        return "DIRECT";
    else
        return "PROXY 10.0.8.13:3128";
}