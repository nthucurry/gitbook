# 參考來源
- [從實戰經驗看到的 K8S 導入痛點](https://hackmd.io/@k8ssummit/20/%2F%40k8ssummit%2FByyAVbANv?fbclid=IwAR3q1kuVs8Sc9BF3L0cbPJA1twtx31IE17aq6JIwBqY7BCV5iK8U47-2pXE)
- [Lightweight Kubernetes Showdown: Minikube vs. K3s vs. MicroK8s](https://www.itprotoday.com/cloud-computing-and-edge-computing/lightweight-kubernetes-showdown-minikube-vs-k3s-vs-microk8s)
- [Microk8s vs K3s](https://thechief.io/c/editorial/microk8s-vs-k3s/)

# 缺乏現代化 Infra 管理經驗
## 缺乏自動化管理能力
- 現有 Infra 經驗都是管理虛擬機器為主
- 極度缺乏對 Infra 的自動化管理能力
- 不知道如何將 Infra 設定轉換為代碼 ( IaC ) - Terraform / Pulumi / CDK (AWS) / ...
- 對於 DevOps 或 CI/CD 沒有完整的概念

## 缺乏容器化技術的使用經驗
- 沒有實際將應用系統容器化的經驗
- 沒有 Dev/Ops 的分工經驗 (一個人包辦所有開發與維運工作)
- 過渡依賴 GUI 操作界面，不熟悉 CLI 介面操作

## 部署架構混亂且缺乏彈性
- 為了節省 IP 而將大量服務塞到同一台主機上
- 大量的組態飄移 (Configuration Drift) 導致無人可掌握部署環境
- 部署架構缺乏彈性，不容易做到自動橫向延展 (Scale out)
- 開發人員寫出「有狀態」的程式碼，缺乏「分散式」架構觀念

## 效能調校的經驗不足
- 遇到效能問題先調 DB 索引
    - 將資料庫視為「全域變數」來使用
- 無法有效率的使用 CPU / Memory 資源
    - 非同步程式設計
- 缺乏分散式架構的設計經驗
    - 善加利用 Message Queue
    - 設計出可以 Scale out 的程式架構

## 不懂沒關係：不要瞎掰跟腦補
- 對 K8S 有正確的理解，比什麼都還重要!
- 我們是否該選用雲端的 K8S 託管服務? (EKS, AKS, GKE)
- 開發人員不管主機也需要學習 K8S 嗎?
- 維運人員不會寫 Code 可以學 K8S 嗎?
- 我們的服務現在都已經透過 Docker 運行，適合上 K8S 嗎?

## 將現有系統搬上 K8S 的效益
- 導入 Kubernetes 是一把「照妖鏡」
- 透過 Kubernetes 提供的各種抽象改善複雜度問題
    - 想像 K8S 就是「一台」可以自動長大的「單一」伺服器
    - 妥善設計應用程式的顆粒度，提升資源利用率
- 徹底將應用程式 (App) 與基礎架構 (Infra) 進行解耦 (Decoupling)
    - 解構應用程式，盡量以無狀態的方式進行運作
- 徹底簡化 CI / CD 複雜度
    - 只要有 YAML 與 kubectl 就可以掌握一切

## 成功導入 Kubernetes 五步驟
1. 對相關人員進行教育訓練 (Dev/Ops)
2. 將應用程式或系統全面容器化 (開發環境/測試環境/生產環境)
3. 遷移與部署應用程式到 K8S 進行運作
4. 調整 CI / CD 流程並簡化部署程序
5. 對服務進行監控與分析