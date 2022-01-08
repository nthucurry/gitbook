# Install And Setting
## 網站
- [How To Install Apache Web Server On CentOS 7](https://phoenixnap.com/kb/install-apache-on-centos-7)
- 指令
    ```bash
    # install
    yum install httpd -y

    # firewall setting
    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --reload

    systemctl start httpd
    systemctl enable httpd
    ```
- config
    ```bash
    vi /etc/selinux/config
        SELINUX=disabled

    # check firewall setting
    cat /etc/firewalld/zones/public.xml
    ```

## 資料庫
- [MySQL](https://dev.mysql.com/downloads/mysql/)
    - [解決中文顯示亂碼](http://blog.fens.me/linux-mysql-install/)
        - sudo vi /etc/mysql/my.cnf > enter，直接在 my.cnf 最下面新增
            ```bash
            [client]
            default-character-set=utf8
            [mysqld]
            character-set-server=utf8
            collation-server=utf8_general_ci
            ```
        - 重啟 MySQL：`sudo /etc/init.d/mysql restart`
    - 查詢狀態：`systemctl status mysqld.service`
    - 關閉 MySQL 服務：`systemctl stop mysqld.service`
    - 建立空的密碼
        - `systemctl set-environment MYSQLD_OPTS= "--skip-grant-tables"`
        - `systemctl start mysql`
      - mysql -u 使用者 -p
        ```sql
        USE mysql;
        UPDATE user SET authentication_string=PASSWORD('密碼') WHERE User='使用者';
        flush privileges;
        ```
- Mariadb
    - 安裝步驟：`yum -y install mariadb-server`
    - 啟動：`systemctl start mariadb`
    - 設定 root 密碼：`mysql_secure_installation` \[enter\]，然後一直 \[Y\]
    - 登入：`mysql -u root -p`
    - 建立使用者：`CREATE USER '使用者'@'IP' IDENTIFIED BY '密碼';`
    - 建立資料庫：`CREATE DATABASE dbahr;`
    - 設定使用者權限：`GRANT ALL ON dbahr.- TO '使用者' IDENTIFIED BY '密碼';`
        - 可以防止出現：`ERROR 1045 (28000): Access denied for user 'user'@'localhost' (using password:YES)`
        - 一定要 key 密碼
    - 最後：`FLUSH PRIVILEGES;`
- MongoDB
      - 安裝指令：`sudo apt-get install mongodb`
        - 遇到 Could not get lock /var/lib/dpkg/lock-frontend - open 直接重開機就好
    - [如何開啟 port](https://www.mkyong.com/mongodb/mongodb-allow-remote-access/)
    - 啟動 mongo：`/etc/init.d/mongod start`
    - [刪除 mongo](https://www.anintegratedworld.com/uninstall-mongodb-in-ubuntu-via-command-line-in-3-easy-steps/)
        - `sudo apt-get purge mongodb*`
        - `sudo rm -r /var/log/mongodb`
        - `sudo rm -r /var/lib/mongodb`
    - [開啟 Remote IP](https://stackoverflow.com/questions/30884021/mongodb-bind-ip-wont-work-unless-set-to-0-0-0-0)
        - 編輯：`sudo vi /etc/mongodb.conf`
            - `bind_ip = 0.0.0.0`
            - `port = 27017`
        - 重啟：`service mongodb restart`
        - 確認：`nmap -p 27017 192.168.56.100`
# 虛擬化
- Docker
    ```bash
    # 安裝 curl
    sudo apt install curl

    # 安裝 docker
    curl -sSL https://get.docker.com/ubuntu/ | sudo sh

    # 新增 docker 帳號
    sudo usermod -aG docker 帳號
    ```
# 其他
- 開機執行 shell
    - `vi /etc/rc.local`
    - crontab
        - `* * * * * /etc/init.d/ssh/start`
- 中文介面
    - Ubuntu：`sudo locale-gen`
- 改固定 IP
    ![change IP](../../file/img/setting/linux/設定固定IP.png)
- SSH 登入
    - [https://www.arthurtoday.com/2010/08/ubuntu-ssh.html](https://www.arthurtoday.com/2010/08/ubuntu-ssh.html)
- Git：
    - 安裝：yum install git
    - 產生 ssh key：``ssh-keygen -t rsa -b 4096 -C "xxx@xxx"``
    - `xclip -sel clip < ~/.ssh/id_rsa.pub`
    - 複製全部文字：cat ~/.ssh/id_rsa.pub
    - 到 GitLab 網站的 SSH Keys 把這段文字貼上去
    - 設定識別資料
        ```bash
        git config --global user.email "xxx@xxx"
        git config --global user.name "John Doe"
        ```
- [GitLab on CentOS 7](https://about.gitlab.com/installation/#centos-7)
    - 安裝步驟
        ```bash
        # 基本配備
        sudo yum install -y curl policycoreutils-python openssh-server
        sudo systemctl enable sshd
        sudo systemctl start sshd
        sudo firewall-cmd --permanent --add-service=http
        sudo systemctl reload firewalld
        # 如果有需要用 email
        sudo yum install postfix
        sudo systemctl enable postfix
        sudo systemctl start postfix
        # 安裝 GitLab package repository
        curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
        # 更改 Domain Name
        # 修改網域 vi /etc/gitlab/gitlab.rb
        # 重新佈署 gitlab-ctl reconfigure
        sudo EXTERNAL_URL="http://localhost" yum install -y gitlab-ee
        ```
    - 安裝完後再 VM 網址輸入`http://gitlab.localhost`就可以進入網站
    - 建好帳號後，測試`ssh git@192.168.227.131`是否可以
- DBeaver
- Brackets
- [krita](https://krita.org/en/)
- [Wireshark](http://self.jxtsai.info/2016/10/wireshark-for-ubuntu.html)
    - `sudo add-apt-repository ppa:wireshark-dev/stable`
    - `sudo apt-get update`
    - `sudo apt-get install wireshark`
    - 出現"Can't run /usr/bin/dumpcap in child process Permission denied"時，執行`sudo adduser $USER wireshark`
    - 再把`sudo tcpdump -q -nn -w log`用 Wireshark 開啟
- [Shutter](https://magiclen.org/shutter/)
- FreeFileSync
- [FB Messenger](https://messengerfordesktop.com/)
- [PCMAN](https://wiki.ubuntu-tw.org/index.php?title=PCMAN)
- [GrADS](http://cola.gmu.edu/grads/)
  - 安裝在`/usr/local/bin`
        - Source Code 安裝
            - 解壓縮`tar xzvf grads-2.2.1-bin-centos7.4-x86_64.tar`
        - Ubuntu
            - sudo apt-get install grads
      - 安裝地圖
        - 放在`/usr/local/lib`
        - 解壓縮`tar xzvf /.../.../data2.tar`
    - 設定環境變數
        - `vi ~/.bashrc > enter`
              - 加上`export PATH=$PATH:/usr/...`
        - `source ~/.bashrc`
    - 執行指令
        - `grib2ctl.pl xxx.grib > xxx.ctl`
        - `gribmap -i xxx.ctl yyy.idx`
- [NCL](https://www.ncl.ucar.edu)
  - NCL 安裝在：`/usr/local/ncl`
    - 解壓縮：`tar zxfv  ncl_ncarg-6.4.0-CentOS6.8_64bit_gnu447.tar.gz`
    - 產出`bin`、`include`、`lib`
  - vi .bashrc > enter
    ```bash
    export NCARG_ROOT=/usr/local/ncl
    export PATH=$NCARG_ROOT/bin:$PATH
    ```
- Fortran
  - `sudo apt-get install gfortran`
- Chrome(CentOS)
    - `sudo vi /etc/yum.repos.d/google.repo`
        ```bash
        [google64]
        name=Google - x86_64
        baseurl=http://dl.google.com/linux/rpm/stable/x86_64
        enabled=1
        gpgcheck=1
        gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
        ```
    - 安裝`sudo yum install google-chrome-stable`
- C++編譯器
    - 安裝：`yum group install "Development Tools"`
- WidesShark
    - `sudo yum install wireshark wireshark-qt`
- 防火牆([ufw](https://noob.tw/ufw/), Uncomplicated Firewall)
    - 安裝指令：`sudo apt-get install ufw`
    - `sudo ufw deny from 192.168.11.7 to any port 22`
    - `sudo iptables -A INPUT -p tcp --dport 27017 -j ACCEPT`
- 觀看網路狀況
    - 安裝：`sudo apt-get install nmap`
# 調整組態
- Network Time Protocol
    - `timedatectl set-ntp yes`
    - `timedatectl set-timezone "Asia/Taipei"`
- 將使用者設定成 root 權限
    - `visudo > enter`
        找到  `root    ALL=(ALL) ALL`
        加上  `tony    ALL=(ALL) ALL`
    - `vi /etc/passwd`
        權限改 0
- 群組
    - 建立群組：`groupadd dbahr`
    - 資料夾批次改群組：`chown -R root:dbahr ./dbahr/`
    - 使用者新增其他群組：`usermod -a -G dbahr tony`
    - 使用者加入群組：`usermod -G dbahr tony`
    - 檢查群組：`grep tony /etc/group`
        ```bash
        tony:x:1001:
        dbahr:x:1002:tony
        ```
    - 更改使用者群組：`usermod -g dbahr tony`
- 改 vi 顏色
    - `vi .bashrc > enter`
    - `alias vi='vim'`
    - `source .bashrc`
- 改 vim 設定
    - `vi ~/.vimrc > enter`
    - `set cindent (自動縮排)`
    - `set cursorline (底線 目前游標位置)`
    - `syntax on (語法上色)`
- [讓終端機有顏色](http://sodahau.logdown.com/posts/18879-mac-ls)
    - `vi ~/.bash_profile > enter`
    - `export CLICOLOR='true'`
    - `source ~/.bash_profile`
- 別名 alias
    - `vi ~/.bash_profile > enter`
    - `alias ll='ls -al'`
    - `source ~/.bash_profile`
- 終端機模式
    ```bash
    sudo update-grub
    sudo systemctl set-default multi-user.target
    ```
- 設定主機名稱
# 查詢指令
- IP：ip a 找名稱為 enp0s8
- Kernel：`cat /etc/* -release`
- hostname
    - hostname：取得目前本機設定好的 Hostname
    - hostname –i：取得目前本機 Hostname 對應的 IP
    - hostname –I：取得目前本機設定好的所有 IP 位址
- 查詢 80 port 是否開啟：`netstat -ntlp`
    ```text
    tcp        0      0 0.0.0.0:111             0.0.0.0:-               LISTEN      -
    tcp        0      0 192.168.122.1:53        0.0.0.0:-               LISTEN      -
    tcp        0      0 0.0.0.0:22              0.0.0.0:-               LISTEN      -
    tcp        0      0 127.0.0.1:631           0.0.0.0:-               LISTEN      -
    tcp        0      0 127.0.0.1:25            0.0.0.0:-               LISTEN      -
    tcp6       0      0 :::111                  :::-                    LISTEN      -
    tcp6       0      0 :::80                   :::-                    LISTEN      -
    tcp6       0      0 :::22                   :::-                    LISTEN      -
    tcp6       0      0 ::1:631                 :::-                    LISTEN      -
    tcp6       0      0 ::1:25                  :::-                    LISTEN      -
    ```
- 出現以上代表已經是 IPv4/IPv6 兩種環境同時支援的服務了
- 如果關掉`systemctl stop httpd`，輸入`netstat -ntlp`則顯示
    ```text
    tcp        0      0 0.0.0.0:111             0.0.0.0:-               LISTEN      -
    tcp        0      0 192.168.122.1:53        0.0.0.0:-               LISTEN      -
    tcp        0      0 0.0.0.0:22              0.0.0.0:-               LISTEN      -
    tcp        0      0 127.0.0.1:631           0.0.0.0:-               LISTEN      -
    tcp        0      0 127.0.0.1:25            0.0.0.0:-               LISTEN      -
    tcp6       0      0 :::111                  :::-                    LISTEN      -
    tcp6       0      0 :::22                   :::-                    LISTEN      -
    tcp6       0      0 ::1:631                 :::-                    LISTEN      -
    tcp6       0      0 ::1:25                  :::-                    LISTEN      -
    ```
- `lsof -i -P -n | grep :80`
    - httpd  8326 apache  4u  IPv6 2394078  0t0  TCP :80 \(LISTEN\)
- 列出已連線的網路連線狀態：`netstat -tun`
    ```text
    Proto Recv-Q Send-Q Local Address           Foreign Address         State
    tcp        0      0 192.168.56.101:22       192.168.56.1:53692      ESTABLISHED
    tcp        0     64 192.168.56.101:22       192.168.56.1:54168      ESTABLISHED
    tcp6       0      0 192.168.56.101:80       192.168.56.1:54206      TIME_WAIT
    ```
# Shared Deirectory
1. vmware-hgfsclient
1. 強制安裝共享資料夾(Host)
    1. vi /etc/fstab
    1. .host:/D /mnt/hgfs       fuse.vmhgfs-fuse allow_other,defaults 0 0
    1. reboot