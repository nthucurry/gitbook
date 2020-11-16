# RAC
## 安裝順序
1. grid infrastructure(ASM)
2. oracle database

## 安裝 ASM Library
```bash
# ASM library
yum install kmod-oracleasm -y
```

## 網路架構
- public IP
    - rac-1: 10.140.1.11
    - rac-2: 10.140.1.12
- private IP
    - rac-1: 192.168.182.11
    - rac-2: 192.168.182.12
- virtual IP(VIP)
    - rac-1: 10.140.1.11
    - rac-2: 10.140.1.12