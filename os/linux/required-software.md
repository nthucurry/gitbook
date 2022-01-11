- [Internet Traffic Setting](#internet-traffic-setting)
- [VNC Server](#vnc-server)
- [ProxyChains](#proxychains)
- [GUI](#gui)
- [X Window System](#x-window-system)
- [NFS](#nfs)
    - [Host](#host)
    - [Client](#client)
- [Lansweep Agent](#lansweep-agent)

# Internet Traffic Setting
```bash
echo "export http_proxy=http://10.1.0.4:3128" >> /etc/bashrc
echo "export https_proxy=http://10.1.0.4:3128" >> /etc/bashrc
source /etc/bashrc
```

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
service vncserver start && chkconfig vncserver on

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

# ProxyChains
```bash
yum install git -y
git config --global http.proxy http://10.1.0.4:3128
git clone https://github.com/rofl0r/proxychains-ng.git
cd proxychains-ng
./configure && make && make install
make install-config
```

# GUI
```bash
# CentOS 7
yum groupinstall "GNOME Desktop" -y

# CentOS 6
yum remove WALinuxAgent -y
yum groupinstall "X Window System" "Desktop" "Fonts" "General Purpose Desktop"
yum remove NetworkManager WALinuxAgent -y
yum groupinstall 'Graphical Administration Tools' -y
startx
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
- [CentOS 7 下 yum 安装和配置 NFS](https://qizhanming.com/blog/2018/08/08/how-to-install-nfs-on-centos-7)
- host & client 安裝 `yum install nfs-utils`

## Host
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

## Client
```bash
systemctl start rpcbind
systemctl enable rpcbind

# mount NFS when startup
vi /etc/fstab
# 目標主機名稱:/backup /backup nfs defaults 0 0

# 重新載入 systemd 的腳本設定檔內容
systemctl daemon-reload
```

# Lansweep Agent
- CentOS 6 troubleshooting
    - http://ailog.tw/lifelog/2021/03/15/centos-6-yum/
    - https://blog.tomy168.com/2021/03/centos6yum.html
    - https://iter01.com/68338.html
    - https://itbilu.com/linux/management/NymXRUieg.html
- 基本動作
    ```bash
    yum update -y
    yum install epel-release -y
    yum install gcc gcc-c++ gcc-g++ texinfo -y
    ```
- 下載 Lansweep Agent
    ```bash
    wget https://cdn.lansweeper.com/build/lsagent/LsAgent-linux-x64_8.4.100.35.run
    chmod +x LsAgent-linux-x64_8.4.100.35.run
    ```
- 下載微軟套件包
    ```bash
    # CentOS 7
    rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

    # CentOS 6
    rpm -Uvh https://packages.microsoft.com/config/centos/6/packages-microsoft-prod.rpm
    ```
- 安裝 dotnet runtime
    ```bash
    wget https://download.visualstudio.microsoft.com/download/pr/8a11a2ba-d599-486f-ba61-9e420bc4a2bb/db9d61f28e0a688adc83687b611702ff/dotnet-runtime-3.1.22-linux-x64.tar.gz
    mkdir -p $HOME/dotnet && tar zxf dotnet-runtime-3.1.22-linux-x64.tar.gz -C $HOME/dotnet
    echo "export DOTNET_ROOT=$HOME/dotnet" >> /etc/bashrc
    echo "export PATH=$PATH:$HOME/dotnet" >> /etc/bashrc
    echo "export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1" >> /etc/bashrc # CentOS 6
    source /etc/bashrc
    ```
- 此時執行 dotnet 會出現問題
    ```
    [root@t-cent6 ~]# dotnet
    dotnet: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by dotnet)

    [root@t-cent6 ~]# ll /lib64/libc.so.6
    lrwxrwxrwx. 1 root root 12 Apr 29  2020 /lib64/libc.so.6 -> libc-2.12.so (X)
    lrwxrwxrwx. 1 root root 12 Jan  8 15:24 /lib64/libc.so.6 -> libc-2.14.so (O)

    [root@t-cent6 ~]# ll /usr/lib64/libstdc++.so.6
    lrwxrwxrwx. 1 root root 19 Apr 29  2020 /usr/lib64/libstdc++.so.6 -> libstdc++.so.6.0.13 (X)
    lrwxrwxrwx. 1 root root 19 2022-01-09 04:57 /usr/lib64/libstdc++.so.6 -> libstdc++.so.6.0.22 (O)

    [root@t-cent6 lib64]# strings /usr/lib64/libstdc++.so.6 | grep GLIBCXX_3.4.18
    GLIBCXX_3.4.18 (O)
    ```
- 解決缺少 GLIBC_2.14、GLIBCXX_3.4.18 的問題
    ```bash
    # dotnet: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by dotnet)
    wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
    mkdir glibc-2.14 && tar zxf glibc-2.14.tar.gz
    cd glibc-2.14
    mkdir build && cd build
    ../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
    make && make install
    # 執行後會有些錯誤，可忽略

    # Failed to load X?r?V, error: /usr/lib64/libstdc++.so.6: version `GLIBCXX_3.4.18' not found (required by /root/dotnet/host/fxr/3.1.22/libhostfxr.so)
    wget http://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.xz
    tar -xf gcc-6.4.0.tar.xz -C /usr/src
    cd /usr/src/gcc-6.4.0
    sed -i 's/wget ftp/wget http/g' ./contrib/download_prerequisites
    ./contrib/download_prerequisites
    ./configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
    make -j4 && make install # 超久 (~2hr)

    ls /usr/local/bin | grep gcc

    cd /usr/lib64
    cp /usr/src/gcc-6.4.0/stage1-x86_64-pc-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.22 libstdc++.so.6.0.22
    mv libstdc++.so.6 libstdc++.so.6.old
    ln -sv libstdc++.so.6.0.22 libstdc++.so.6
    ```
- dotnet 安裝完成
    ```
    [root@t-cent6 ~]# dotnet --version
      It was not possible to find any installed .NET Core SDKs
      Did you mean to run .NET Core SDK commands? Install a .NET Core SDK from:
         https://aka.ms/dotnet-download
    ```
- 安裝 Agent
    ```bash
    $HOME/LsAgent-linux-x64_8.4.100.35.run
    ```