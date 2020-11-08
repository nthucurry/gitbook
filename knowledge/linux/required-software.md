# 必備軟體
## VNC Server
```bash
# 安裝
yum install tigervnc-server -y

# 複製 service config
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:2.service

# 修改 service config
sed -i 's/<USER>/root/g' /etc/systemd/system/vncserver@:1.service
sed -i 's/<USER>/demo/g' /etc/systemd/system/vncserver@:2.service

# 確認 root 的路徑是否正確(option)
vi /etc/systemd/system/vncserver@:1.service
PIDFile=/root/.vnc/%H%i.pid
vi /etc/systemd/system/vncserver@:2.service
PIDFile=/home/demo/.vnc/%H%i.pid

# 登入各個帳號去設定以下(systemctl daemon-reload??)
systemctl start vncserver@:1.service vncserver@:2.service
systemctl enable vncserver@:1.service vncserver@:2.service

# 設定密碼
vncserver(啟動 vnc server，需依照各別 user account)
vncpasswd
vncserver -kill :1

# 重啟
reboot

# 檢查
netstat -tln
tcp 0 0 0.0.0.0:5901 0.0.0.0:* LISTEN
```

## X Window System
```bash
# 需要直接 login demo
cd ~
vi .Xclients
# xterm &
# exec /usr/bin/matchbox-window-manager

chmod +x .Xclients
~/.Xclients # remember open xming
```

## NFS
[CentOS 7 下 yum 安装和配置 NFS](https://qizhanming.com/blog/2018/08/08/how-to-install-nfs-on-centos-7)
- host & client 安裝 `yum install nfs-utils`
- host
    ```bash
    # startup NFS(Network File System)
    systemctl start rpcbind nfs
    systemctl enable rpcbind nfs

    # firewall setting
    firewall-cmd --zone=public --permanent --add-service={rpc-bind,mountd,nfs}
    firewall-cmd --reload

    # check NFS
    vi /etc/exports
    # /backup    192.168.56.0/24(rw,sync)

    systemctl restart nfs

    showmount -e localhost
    ```
- client
    ```bash
    systemctl start rpcbind
    systemctl enable rpcbind

    # mount NFS when startup
    vi /etc/fstab
    # 目標主機名稱:/backup_new         /backup_new                   nfs     defaults        0 0

    # 重新載入 systemd 的腳本設定檔內容
    systemctl daemon-reload
    ```