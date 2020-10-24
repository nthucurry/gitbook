# MacOS
## 生產工具
- [PyCharm](https://www.jetbrains.com/pycharm/download/#section=mac)
- [DBeaver](https://dbeaver.jkiss.org/)
- [AppCleaner](https://freemacsoft.net/appcleaner/)
- [VLC](https://www.videolan.org/vlc/download-macosx.zh-TW.html)
    - 可在 preference 轉成 中文
- [Transmission](https://transmissionbt.com/download/)
- [Mounty for NTFS 讀 NTFS](http://enjoygineering.com/mounty/#FAQs)
- [KeKa 壓縮工具](http://www.kekaosx.com/zh-tw/)
- [Nally BBS](http://yllan.org/app/Nally/)
- [XQuartz](https://www.xquartz.org/)
    - `ssh -X user@hostname`

## 環境設定
### vimrc
- `vi ~/.vimrc`
    ```bash
    syntax enable
    set background=dark
    ```

### bash_profile
- `vi ~/.bash_profile`
    ```bash
    cd /Users/tony/Documents
    #df -h | grep "/dev/disk2s1"; df -h | grep "/dev/disk3s1";
    df -h | grep "dev/.*s1" | awk '{print $1 "\t" $2 "\t" $4 "\t" $5}'

    #export PS1="\[\e[30;46m\]\u:\W \\$ \[\e[0m\]" # http://xta.github.io/HalloweenBash/
    PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

    export PATH
    export CLICOLOR='true'

    alias ll='ls -al'
    alias vi='vim'
    alias grep='grep --color=auto'
    alias tree='tree -N'
    alias ping='ping -c 4'

    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global user.name "Tony's Mac"
    git config --global user.email "xu3ej04u454@gmail.com"
    ```

### 啟動 root
- `sudo passwd root`
- 輸入 apple password
- done!

### Launchpad 排列方式
設定專屬的 Launchpad 排列方法 (initial: 7 columns \- 5 rows)
- 直向：`defaults write com.apple.dock springboard-rows -int 8`
- 橫向：`defaults write com.apple.dock springboard-columns -int 8`
- 完成：`killall Dock`

### [關閉 spotlight](https://ppt.cc/fnWirx)
- disable System Integrity Protection
    - reboot into recovery mode: Command+R
    - csrutil disable (開啟: csrutil enable)
- restrat system
- `sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist`

### 用 ssh 登入 linux
- server 端: `vi ~/.ssh/authorized_keys`
- 將 local 端 public key 加到 server 端的 authorized_keys
- ok

### Homebrew
- 安裝方式
    - 用一般 User，會一直 key 密碼: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
    - 安裝好後再 `brew update`
- 必裝，讓 macOS 有 linux 溫度
    - `brew install coreutils`
        ```bash
        PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
        export PATH
        ```
    - `brew install gnu-sed`

## 開發工具
### Java
- oracle: [JDK 8](https://ppt.cc/f0NTMx)，注意！！Netbeans 須和 JDK 版本一致
- openJDK
    - 下載 IDE
        - 此處下載需先安裝 java
        - https://www.apache.org/dyn/closer.cgi/netbeans/netbeans/12.0/Apache-NetBeans-12.0-bin-macosx.dmg
        - https://www.apache.org/dyn/closer.cgi/netbeans/netbeans/11.2/
        - 更改 Code Templates：Preferences > Editor > Code Templates
            - sout 改成：`System.out.println(${cursor});`
        - [PHP](https://windows.php.net/download/) 記得下載執行檔放在 php 5 interpreter，才可以執行
    - `brew cask install adoptopenjdk`

### [MariaDB](https://hoyangtsai.github.io/posts/2015/12/09/mac-using-homebrew-install-mariadb/)
- 安裝指令：`brew install mariadb`
- 啟動方式
    - 手動：`mysql.server start`
    - 自動：`brew services start mariadb`
    - 登入啟動：[https://n.sfs.tw/content/index/11776](https://n.sfs.tw/content/index/11776)
- 登入測試：`mysql -u root`

## Troubleshooting
### [【教學】重灌 Mac 機必用！教你以 Terminal 製作 macOS Sierra 安裝手指！](https://ppt.cc/f0O1lx)
```bash
sudo /Users/fool/Downloads/Install\ macOS\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/Mac --applicationpath /Users/fool/Downloads/Install\ macOS\ Sierra.app --nointeraction
```

### 故障處理方法
- 清 PRAM：重開機後會聽到「噹」一聲後立刻按下 **⌘＋option＋P＋R**
- 重置 SMC：**Shift＋Control＋Option**- 鍵以及電源按鈕

### 維修網站
- [Save Apple Dollars](http://www.appledollars.com/)
- [iFixit](https://www.ifixit.com/Device/Mac)

### 休眠耗電的解決辦法
[https://udn.com/news/story/11017/3433052](https://udn.com/news/story/11017/3433052)