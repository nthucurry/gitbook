# GitLab
## Client
- 如果有兩組 ssh 以上，需建立 config [如果沒建立，會出現 Permission denied (publickey)]
    - vi config
        ```txt
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

## Secret