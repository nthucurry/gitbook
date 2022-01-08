# VNC Server
```bash
# 安裝
yum install tigervnc-server -y

# 複製 service config
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service

# 修改 service config
sed -i 's/<USER>/oracle/g' /etc/systemd/system/vncserver@:1.service

# 確認 root 的路徑是否正確(option)
vi /etc/systemd/system/vncserver@:1.service
PIDFile=/home/oracle/.vnc/%H%i.pid

# 登入各個帳號去設定以下(systemctl daemon-reload??)
systemctl start vncserver@:1.service && systemctl enable vncserver@:1.service

# 設定密碼
vncserver(啟動 vnc server，需依照各別 user account)
vncpasswdc
vncserver -kill :1

# 重啟
reboot

# 檢查
netstat -tln
tcp 0 0 0.0.0.0:5901 0.0.0.0:* LISTEN
```

# GUI
```bash
# CentOS 7
yum groupinstall "GNOME Desktop" -y

# CentOS 6
yum groupinstall "Desktop" -y --skip-broken
```

# X Window System
```bash
# 需要直接 login demo
cd ~
echo "xterm &" >> .Xclients
echo "exec /usr/bin/matchbox-window-manager" >> .Xclients
chmod +x .Xclients
~/.Xclients # remember open xming
```

# NFS
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
    # /backup 192.168.56.0/24(rw,sync)

    systemctl restart nfs

    showmount -e localhost
    ```
- client
    ```bash
    systemctl start rpcbind
    systemctl enable rpcbind

    # mount NFS when startup
    vi /etc/fstab
    # 目標主機名稱:/backup /backup nfs defaults 0 0

    # 重新載入 systemd 的腳本設定檔內容
    systemctl daemon-reload
    ```

# CentOS 6
```bash
yum install epel-release -y # epel-release-6-8.noarch
yum install gcc -y # gcc version 4.4.7 20120313 (Red Hat 4.4.7-23) (GCC)

wget http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2
tar -jxvf gcc-4.8.2.tar.bz2
cd gcc-4.8.0
./contrib/download_prerequisites
```

# Lansweep Agent
```bash
wget https://cdn.lansweeper.com/build/lsagent/LsAgent-linux-x64_8.4.100.35.run
chmod +x LsAgent-linux-x64_8.4.100.35.run

rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
rpm -Uvh https://packages.microsoft.com/config/centos/6/packages-microsoft-prod.rpm

wget https://download.visualstudio.microsoft.com/download/pr/ede8a287-3d61-4988-a356-32ff9129079e/bdb47b6b510ed0c4f0b132f7f4ad9d5a/dotnet-sdk-6.0.101-linux-x64.tar.gz
mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-6.0.101-linux-x64.tar.gz -C $HOME/dotnet

yum install dotnet-sdk-6.0
./LsAgent-linux-x64_8.4.100.35.run
```