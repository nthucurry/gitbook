# Application Gateway
## Reference
- [Azure - Difference between Azure Load Balancer and Application Gateway](https://medium.com/awesome-azure/azure-difference-between-azure-load-balancer-and-application-gateway-9a6019c23840)
- [如何在 IIS7 / IIS7.5 安裝 SSL 憑證(含 IIS7 匯入憑證的 Bug)](https://blog.miniasp.com/post/2011/08/14/How-to-import-SSL-certificate-to-IIS7-without-any-problem)
- [如何在收到 PFX 或 CER 憑證檔之後使用 OpenSSL 進行常見的格式轉換](https://blog.miniasp.com/post/2019/04/17/Convert-PFX-and-CER-format-using-OpenSSL)

## 架構
- OSI
    - ![](https://img-blog.csdnimg.cn/20181228120335803.jpg)
    - ![](https://img-en.fs.com/community/wp-content/uploads/2017/11/seven-layers-of-OSI-model.png)

## 原理
### Beforehand
- SSL: HTTP(瀏覽器) 和 TCP(Server) 之間的加密方式
- 數位憑證
    ```txt
    數位憑證(Digital ID)係結合一對可以用來加密及簽章的電子金鑰。簡單的說，數位憑證可以用來核驗宣稱擁有金鑰使用權者的身分，並且可以避免第三者使用偽造的金鑰來頂替真正的合法使用者。數位憑證與加密的技術相結合後，可以提供更高等級的安全性，進而保障進行線上交易的每一方。
    ```
    - 根憑證(root certificate)
        - 來自於公認可靠的政府機關、軟體公司、憑證頒發機構公司...等
        - 部署程序複雜費時，需要行政人員的授權及機構法人身分的核認，一張根憑證有效期可能長達十年以上
    - 中介憑證

###
管理 web app 流量(traffic)的網路流量負載平衡器(load balancer)，可針對特定協定來控管，例如 http or image...etc，也稱為 OSI Lev 7 負載平衡

### Small steps to big savings
- CRT + KEY --> PFX
    - http://dog0416.blogspot.com/2017/08/opensslwindows-crt-key-pfx.html