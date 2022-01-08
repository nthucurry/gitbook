# Linux Tip
## 必裝
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
#yum install iptables-services -y

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

## ssh 用 alias name login
[How to use host names rather than ip addresses on home network?](https://askubuntu.com/questions/150617/how-to-use-host-names-rather-than-ip-addresses-on-home-network)

## How to resolve emergency mode
```txt
Welcome to emergency mode! After logging in, type "journalctl -xb" to view
system logs, "systemctl reboot" to reboot, "systemctl default" to try again
to boot into default mode.
Give root password for maintenance
(or type Control-D to continue):

mount -a
```

## 環境變數
```bash
# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

# terminal color
export PS1="\[\e[30;42m\]\u@\h:\W \A \\$ \[\e[0m\]"

# alias
alias rm='rm -i'
alias vi='vim'
alias grep='grep --color=always'
alias tree='tree --charset ASCII'
```

# 增加 history 時間資訊
```bash
vi ~/.bashrc
# HISTTIMEFORMAT='%F %T  '
source ~/.bashrc
```

# 看登入紀錄
```bash
sudo cat /var/log/secure | grep 192.168.56.101
sudo cat /var/log/secure | grep "Failed password"
```

# 找資料夾
```bash
find ./* -iname "*ProductUI*" -type d
```

# 計算數量若出現 Argument list too long
```bash
find ./* -iname "*.java" -exec cat {} \; | grep "conn."`
find 路徑 -iname "檔案名稱" -exec 執行指令 {} \; | grep "conn."`
```

# Samba 連結
- `smbclient - L //[windows IP]/資料夾 -U 帳號 > enter`
- `[windows 密碼]`
- 可看見 windows 資料夾

# crontab 預設目錄為根目錄，執行時需設定位置
- 設定系統環境變數(`vi /etc/crontab`)
    ```bash
    SHELL=/bin/sh
    PATH=/usr/bin:/.......:usr/lib/jdk/bin
    ```
- 設定使用者環境變數(`crontab -e`)
    - `HOME=/home/tony`
- 可檢查 log：`/var/spool/mail/tony`

# Linux 中文化
- `vi /etc/default/locale > enter`
- `LANG="zh_TW.UTF-8"`
- `LANGUAGE="zh_TW:en"`
- `sudo locale=gen`
- 完成

# 利用 shell 建立 scp 批次處理
```bash
#!/usr.bin.expect -f
spawn scp -r 帳號@IP:來源目錄 目的目錄
set timeout 300
expect "password:"
send "密碼\r"
expect eof
```

# CentOS 7 建立一個可以執行 sudo 的帳號
- `sudo visudo`
    ```txt
    ## Allow root to run any commands anywhere
    root    ALL=(ALL)       ALL
    oracle  ALL=(ALL)       ALL
    ```

# 修改 group GID
- 原本
    ```bash
    cat /etc/group | sort -i | grep -P "(dba|oinstall)"

    # dba:x:601:oracle,oraeship
    # oinstall:x:602:oraeship

    # -rwxrwxrwx. 1 501 1001   219494400 Apr 21 16:37 eship_arch_71050_1_1038328661.bak
    ```
- 修改後
    ```bash
    groupmod -g 501 dba
    groupmod -g 502 oinstall
    usermod -u 501 oraeship

    # dba:x:601:oracle,oraeship
    # oinstall:x:602:oraeship

    # -rwxrwxrwx. 1 501 1001   219494400 Apr 21 16:37 eship_arch_71050_1_1038328661.bak
    ```

- cat /etc/passwd | sort -i | grep -P "(ora)"
- pkill -u oraeship pid

# 無法 yum
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

# 設定 sshd
```txt
Port 22
PermitRootLogin no
PasswordAuthentication yes
PermitEmptyPasswords no
PubkeyAuthentication yes
X11Forwarding yes
```