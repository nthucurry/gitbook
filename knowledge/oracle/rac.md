# RAC
```bash
# ASM library
yum install kmod-oracleasm -y
```

## 網路架構
- public IP
    - rac-1: 10.140.1.11
    - rac-2: 10.140.1.12
- private IP
    - rac-1: 192.168.182.111
    - rac-2: 192.168.182.112
- virtual IP(VIP)
    - rac-1: 10.140.1.11
    - rac-2: 10.140.1.12