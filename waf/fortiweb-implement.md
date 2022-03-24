# Firewall before WAF
- Firewall (DNAT)
    - Internet → Web Public IP → Load Balancer (WAF) IP
- Load Balancer
    - WAF subnet → WAF Instance
- WAF
    - 設定外層 IP (WAF)
        - Virtual IP → Load Balancer IP
        - Interface → Port 1
    - Virtual Server
    - Server Pool (Web)
        - Type → Reverse Proxy
        - IP → Web IP
    - Route
        - 0.0.0.0/0 → Firewall
- Azure
    - NSG Inbound: Internet → Any (VNet 也可以)

# Load Balancer before WAF
- WAF
    - 設定外層 IP (WAF)
        - Virtual IP → Public IP
        - Interface → Port 1
    - Virtual Server
    - Server Pool (Web)
        - Type → Reverse Proxy
        - IP → Web IP
- Azure
    - NSG Inbound: Internet → Any (VNet 也可以)