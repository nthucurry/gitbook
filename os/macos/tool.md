- [生產工具](#生產工具)
- [環境設定](#環境設定)
    - [vimrc](#vimrc)
    - [Profile](#profile)
    - [啟動 root](#啟動-root)
    - [Launchpad 排列方式](#launchpad-排列方式)
    - [關閉 spotlight](#關閉-spotlight)
    - [用 ssh 登入 linux](#用-ssh-登入-linux)
    - [Homebrew](#homebrew)
- [開發工具](#開發工具)
    - [Java](#java)
    - [MariaDB](#mariadb)
    - [VirtualBox](#virtualbox)
    - [Minikube](#minikube)
    - [Docker](#docker)
    - [VSCode](#vscode)
    - [NVM](#nvm)
- [Troubleshooting](#troubleshooting)
    - [【教學】重灌 Mac 機必用！教你以 Terminal 製作 macOS Sierra 安裝手指！](#教學重灌-mac-機必用教你以-terminal-製作-macos-sierra-安裝手指)
    - [故障處理方法](#故障處理方法)
    - [維修網站](#維修網站)
    - [休眠耗電的解決辦法](#休眠耗電的解決辦法)
    - [出現 xcrun: error](#出現-xcrun-error)
    - [macOS 還原問題](#macos-還原問題)

# 生產工具
- [PyCharm](https://www.jetbrains.com/pycharm/download/#section=mac)
- [DBeaver](https://dbeaver.io/)
- [AppCleaner](https://freemacsoft.net/appcleaner/)
- [VLC](https://www.videolan.org/vlc/download-macosx.zh-TW.html)
    - 可在 preference 轉成 中文
- [Transmission](https://transmissionbt.com/download/)
- [Mounty for NTFS 讀 NTFS](http://enjoygineering.com/mounty/#FAQs)
- [KeKa 壓縮工具](http://www.kekaosx.com/zh-tw/)
- [Nally BBS](http://yllan.org/app/Nally/)
- [XQuartz](https://www.xquartz.org/)
    - `ssh -X user@hostname`

# 環境設定
## vimrc
- `vi ~/.vimrc`
    ```bash
    syntax enable
    set background=dark
    ```

## Profile
- `vi ~/.bash_profile`(bash) or `vi ~/.zshrc`(zsh)
    ```bash
    cd /Users/tony/Documents
    #df -h | grep "/dev/disk2s1"; df -h | grep "/dev/disk3s1";
    df -h | grep "dev/.*s1" | awk '{print $1 "\t" $2 "\t" $4 "\t" $5}'

    #export PS1="\[\e[30;46m\]\u:\W \\$ \[\e[0m\]" # http://xta.github.io/HalloweenBash/
    PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

    export PATH
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

    alias ll='ls -l'
    alias vi='vim'
    alias grep='grep --color=auto'
    alias tree='tree -N'
    alias ping='ping -c 4'

    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global user.name "MBP18"
    git config --global user.email "xu3ej04u454@gmail.com"
    ```

## 啟動 root
- `sudo passwd root`
- 輸入 apple password
- done!

## Launchpad 排列方式
設定專屬的 Launchpad 排列方法 (initial: 7 columns \- 5 rows)
- 直向：`defaults write com.apple.dock springboard-rows -int 8`
- 橫向：`defaults write com.apple.dock springboard-columns -int 8`
- 完成：`killall Dock`

## [關閉 spotlight](https://ppt.cc/fnWirx)
- disable System Integrity Protection
    - reboot into recovery mode: Command+R
    - csrutil disable (開啟: csrutil enable)
- restrat system
- `sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist`

## 用 ssh 登入 linux
- server 端: `vi ~/.ssh/authorized_keys`
- 將 local 端 public key 加到 server 端的 authorized_keys
- ok

## Homebrew
- 安裝方式
    - 用一般 User，會一直 key 密碼
        ```bash
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        ```
    - 安裝好後再: `brew update`
- 必裝，讓 macOS 有 linux 溫度
    - `brew install coreutils`
        ```bash
        PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
        export PATH
        ```
    - `brew install gnu-sed`

# 開發工具
## Java
- oracle: [JDK 8](https://ppt.cc/f0NTMx)，注意！！Netbeans 須和 JDK 版本一致
- 假如想開發，可參考: https://ithelp.ithome.com.tw/articles/10227841
- openJDK
    - 下載 IDE
        - 此處下載需先安裝 java: https://adoptopenjdk.net
        - https://www.apache.org/dyn/closer.cgi/netbeans/netbeans/12.0/Apache-NetBeans-12.0-bin-macosx.dmg
        - https://www.apache.org/dyn/closer.cgi/netbeans/netbeans/11.2/
        - 更改 Code Templates：Preferences > Editor > Code Templates
            - sout 改成：`System.out.println(${cursor});`
        - [PHP](https://windows.php.net/download/) 記得下載執行檔放在 php 5 interpreter，才可以執行
    - `brew cask install adoptopenjdk`

## [MariaDB](https://hoyangtsai.github.io/posts/2015/12/09/mac-using-homebrew-install-mariadb/)
- 安裝指令：`brew install mariadb`
- 啟動方式
    - 手動：`mysql.server start`
    - 自動：`brew services start mariadb`
    - 登入啟動：[https://n.sfs.tw/content/index/11776](https://n.sfs.tw/content/index/11776)
- 登入測試：`mysql -u root`

## VirtualBox
- `brew install --cask virtualbox`
- `sudo install minikube-darwin-amd64 /usr/local/bin/minikube`

## Minikube
- `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64`

## Docker
- `brew tap caskroom/cask`
- `brew install --cask docker`

## VSCode
```json
{
    "workbench.startupEditor": "newUntitledFile",
    "files.trimTrailingWhitespace": true,
    "editor.fontSize": 14,
    "files.autoSave": "onFocusChange",
    "extensions.ignoreRecommendations": true,
    "workbench.iconTheme": "vscode-icons",
    "terminal.integrated.automationShell.linux": "",
    "terminal.integrated.fontSize": 16,
    "git.ignoreMissingGitWarning": true,
    "git.path": "/usr/bin/git"
}
```

## NVM
```txt
zsh compinit: insecure directories, run compaudit for list.
Ignore insecure directories and continue [y] or abort compinit [n]?
```
- `compaudit`
    ```txt
    There are insecure directories:
    /usr/local/share/zsh/site-functions
    /usr/local/share/zsh
    ```
- 修改權限
    ```bash
    sudo chmod -R 755 /usr/local/share/zsh/site-functions
    sudo chown -R docker:root /usr/local/share/zsh/site-functions
    sudo chmod -R 755 /usr/local/share/zsh
    sudo chown -R root:staff /usr/local/share/zsh
    ```

# Troubleshooting
## [【教學】重灌 Mac 機必用！教你以 Terminal 製作 macOS Sierra 安裝手指！](https://ppt.cc/f0O1lx)
```bash
sudo /Users/fool/Downloads/Install\ macOS\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/Mac --applicationpath /Users/fool/Downloads/Install\ macOS\ Sierra.app --nointeraction
```

## 故障處理方法
- 清 PRAM：重開機後會聽到「噹」一聲後立刻按下 **⌘＋option＋P＋R**
- 重置 SMC：**Shift＋Control＋Option**- 鍵以及電源按鈕

## 維修網站
- [Save Apple Dollars](http://www.appledollars.com/)
- [iFixit](https://www.ifixit.com/Device/Mac)

## 休眠耗電的解決辦法
[https://udn.com/news/story/11017/3433052](https://udn.com/news/story/11017/3433052)

## 出現 xcrun: error
- 安裝 xcode: `xcode-select --install`

## macOS 還原問題
- reference
    - https://rizonjet.com/how-to-fix-macbook-error-code-2003f/
- 指令
    - Command（⌘）-R ：安裝 Mac 上所安裝的最新版 macOS。
    - Option-⌘-R ：升級到與 Mac 相容的最新 macOS。
    - Shift-Option-⌘-R ：安裝 Mac 隨附的 macOS，或仍提供使用的最接近版本。
- [如何重新安裝 macOS](https://support.apple.com/zh-tw/HT204904)
    - 您可以使用「macOS 復原」來重新安裝 Mac 作業系統。
    - 確認 Mac 有 Internet 連線，然後將 Mac 開機，並立即按住 Command（⌘）-R，直到您看到 Apple 標誌或其他影像為止。
    - ![重新安裝 macOS](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/macos/Big-Sur/macos-big-sur-recovery-reinstall-macos.jpg)
- 2003f
    - MacBook error code 2003f is a critical error code that can occur due to a problem with its system files. This error can occur in any version of the Mac Operating System. Generally, this error is faced by users while trying to boot in internet recovery mode.
    - [如何重置 Mac 的 SMC](https://support.apple.com/zh-tw/HT201295): 重置系統管理控制器（SMC）可解決某些與電源、電池、風扇和其他功能相關的問題
        - ![按住這三個按鍵時，也同時按住電源按鈕](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/mac/2016-macbook-keyboard-diagram-smc.png)
        - 同時按住這四個按鈕不放 10 秒
        - 放開所有按鍵，然後按住電源按鈕來啟動 Mac
- 1008f: 你的 Mac 嘗試透過互聯網從「macOS 還原」啟動，但不成功
    - [如果 Mac 啟動後顯示 -1008F 錯誤](https://support.apple.com/zh-hk/HT206989)
    - 使用 Option-Command-R 啟動
    - 或停用「啟用鎖」
        1. 將 Mac 關掉。
        1. 使用另一部裝置前往 iCloud.com，並以 Apple ID 登入。
        1. 按一下「尋找 iPhone」。
        1. 從裝置列表中選擇你的 Mac。如果看不到裝置列表，請從頁頂的裝置選單中選擇 Mac。
        1. 等待幾秒鐘，直至「尋找」完成更新 Mac 的最後一個已知位置。
        1. 按一下「從帳戶移除」。如果看不到該選項，請返回頁頂的裝置選單，然後點擊 Mac 名稱旁邊的移除按鈕 。
        1. 系統提示時，按一下「移除」確認操作。