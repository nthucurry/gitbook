# GitLab
## Client
- 如果有兩組 ssh 以上，需建立 config [如果沒建立，會出現 Permission denied (publickey)]
    - `vi config`
        ```
        Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_github

        Host gitlab.ttfri.org.tw
        HostName gitlab.ttfri.org.tw
        User git
        IdentityFile ~/.ssh/id_rsa_gitlab
        ```

## 上傳 Repo
```bash
# 在 Github 建立 Repo
git init
git add .
git ci -m "first commit"
git remote add origin https://github.com/ShaqtinAFool/Fabmedical.git
git push -u origin master
```

## 設定 Proxy
- 無 self signed certificate in certificate chain
    - `git config --global http.proxy http://t-proxy-free:3128`
- 有 self signed certificate in certificate chain