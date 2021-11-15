# 擴磁碟空間
```bash
yum install cloud-utils-growpart gdisk -y
lsblk /dev/sda
growpart /dev/sda 2
lsblk /dev/sda2
xfs_growfs /
```