function FindProxyForURL(url, host) {
    var resolved_ip = dnsResolve(host);
// If the hostname matches, send to the proxy.
//  if (dnsDomainIs(host, "exampldomain.com") ||
//    shExpMatch(host, "(*.abcdomain.com|abcdomain.com)"))
//    return "PROXY 1.2.3.4:8080";
// DEFAULT RULE: All other traffic, send direct.
//  return "DIRECT";
    if (dnsDomainIs(host, "portal.azure.com"))
        return "PROXY 10.248.15.8:3128";
    else
        return "DIRECT";
}