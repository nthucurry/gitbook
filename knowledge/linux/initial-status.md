# Linux 基本設定
## 安裝套件
```bash
# update
yum update -y

# x-windows (there will be problems: Group x11 does not have any packages to install)
#yum groupinstall "X Window System" -y

# full screen on Virtual Box
yum install dkms gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel kernel-headers -y

# else
yum install ntp -y
    timedatectl set-timezone Asia/Taipei
yum groupinstall "GNOME Desktop" -y
yum groupinstall "GNOME Desktop" --setopt=group_package_types=mandatory,default,optional # 遇到問題時
yum install wget -y
yum install tree -y
yum install traceroute -y
yum install telnet -y
yum install tigervnc-server -y
yum install nfs-utils -y
yum install zip unzip -y
#yum install rsync -y
#yum install epel-release -y

# browser
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
#yum install ./google-chrome-stable_current_*.rpm -y

# veeam backup & restore
#yum install veeam -y
#yum install fuse-libs -y
#yum install lvm2 -y

# web
#yum install httpd -y

# iops
#yum install fio -y
```

## 環境變數
- `vi /etc/bashrc`(root)
- `vi ~/.bash_profile`(user)
    ```bash
    # User specific environment and startup programs
    PATH=$PATH:$HOME/.local/bin:$HOME/bin
    export PATH

    # Terminal color
    export PS1="\[\e[30;42m\]\u@\h:\W \A \\$ \[\e[0m\]"

    # Alias
    alias rm='rm -i'
    alias vi='vim'
    alias grep='grep --color=always'
    alias tree='tree --charset ASCII'
    ```

## SSH
- `vi /etc/ssh/sshd_config`
    ```txt
    PasswordAuthentication yes
    PermitRootLogin no
    UseDNS no
    ```
- `systemctl restart sshd`

## Option
### 增加 History 時間資訊
- `vi ~/.bashrc`
    - HISTTIMEFORMAT='%F %T  '
- `source ~/.bashrc`

### Crontab 預設目錄為根目錄，執行時需設定位置
- 設定系統環境變數(`vi /etc/crontab`)
    ```bash
    SHELL=/bin/sh
    PATH=/usr/bin:/.......:usr/lib/jdk/bin
    ```
- 設定使用者環境變數(`crontab -e`)
    - `HOME=/home/tony`
- 可檢查 log：`/var/spool/mail/tony`

### OS 中文化
- `vi /etc/default/locale > enter`
- `LANG="zh_TW.UTF-8"`
- `LANGUAGE="zh_TW:en"`
- `sudo locale=gen`
- 完成

### 無法 Yum
[http://ilms.csu.edu.tw/6736/doc/35571](http://ilms.csu.edu.tw/6736/doc/35571)
- 先刪除 repo: `rm -fr /etc/yum.repos.d/CentOS-*`
- `vi /etc/yum.repos.d/CentOS-Base.repo`
    ```txt
    [base]
    name=CentOS-$releasever – Base
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
    baseurl=http://mirror01.idc.hinet.net/CentOS/$releasever/os/$basearch/
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

    #released updates
    [updates]
    name=CentOS-$releasever – Updates
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
    baseurl=http://mirror01.idc.hinet.net/CentOS/$releasever/updates/$basearch/
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

    #additional packages that may be useful
    [extras]
    name=CentOS-$releasever – Extras
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
    baseurl=http://mirror01.idc.hinet.net/CentOS/$releasever/extras/$basearch/
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

    #additional packages that extend functionality of existing packages
    [centosplus]
    name=CentOS-$releasever – Plus
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
    baseurl=http://mirror01.idc.hinet.net/CentOS/$releasever/centosplus/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

    #contrib – packages by Centos Users
    [contrib]
    name=CentOS-$releasever – Contrib
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib
    baseurl=http://mirror01.idc.hinet.net/CentOS/$releasever/contrib/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    ```