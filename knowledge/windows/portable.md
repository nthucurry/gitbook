# Portable
## Office
- Reflection11.rar
- [rapture-2.2.1](http://www.knystudio.net/index.html)
- [Tablacus Explore](https://tablacus.github.io/explorer_en.html)
- [FileZilla](https://filezilla-project.org/download.php?show_all=1)
- [krita](https://krita.org/en/)

## Terminal
- [cmder](https://cmder.net/)
    - 初始目錄：修改 .\cmder_mini\vendor\init.bat
    - 在 Startup > Tasks > {cmd::Cmder} > 右下角輸入 cmd /k "%ConEmuDir%\..\init.bat"  -new_console:d:D:\
    - 將 lambda 改成 $: \cmder\vendor\clink.lua，找 lambda
    - 環境變數
        ```txt
        set PATH=D:\yyyPortable\cmder\vendor\git-for-windows\usr\bin;%ConEmuBaseDir%\Scripts;C:\Users\Tonylee\AppData\Roaming\npm;%PATH%
        set LANG=zh_TW.UTF8
        alias ll=ls -list
        alias c=clear
        alias cd~=cd /d C:\Users\Tonylee
        ```
- [MTPuTTY](http://ttyplus.com/downloads.html)

## IDE
- [SQL Developer with JDK 8 included](https://www.oracle.com/tw/tools/downloads/sqldev-v192-downloads.html#license-lightbox)
- [dbeaver](https://dbeaver.io/)
- [Visual Studio Code](https://code.visualstudio.com/docs/?dv=winzip)
- [Apache NetBeans](https://netbeans.apache.org/download/nb112/nb112.html)

## Browser
- [Chromium](https://www.chromium.org/Home)
- [Opera](https://www.opera.com/computer/portable)

## Programing
- [OpenJDK](https://jdk.java.net/14/)