# Linux
- Portal
    - 取 token
- CMD
    ```bash
    wget https://vstsagentpackage.azureedge.net/agent/2.204.0/vsts-agent-linux-x64-2.204.0.tar.gz
    mkdir devops-agent
    mv vsts-agent-linux-x64-2.204.0.tar.gz devops-agent/
    cd devops-agent
    tar zxvf vsts-agent-linux-x64-2.204.0.tar.gz
    sudo ./bin/installdependencies.sh
    ./config.sh
    # 請輸入 (Y/N) 現在就接受 Team Explorer Everywhere 授權合約嗎?  (請為 否 按 Enter) > 按 Enter
    # 請輸入 伺服器 URL > https://dev.azure.com/XXX
    # 請輸入 驗證類型 (請為 PAT 按 Enter) > 按 Enter
    # 請輸入 個人存取權杖 > ****************************************************
    # 請輸入 代理程式集區 (請為 default 按 Enter) > Linux
    # 請輸入 代理程式名稱 (請為 t-dol 按 Enter) > 按 Enter
    # 請輸入 工作資料夾 (請為 _work 按 Enter) > 按 Enter
    ./run.sh
    ```
- [Run as a systemd service](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops-2020#run-as-a-systemd-service)
    ```bash
    sudo ./svc.sh install azadmin
    sudo systemctl enable vsts.agent.XXX.Linux.maz\\x2ddevops1.service --now
    systemctl status vsts.agent.XXX.Linux.maz\\x2ddevops1.service
    ```

# Windows
- CMD
    - 類似 Linux SOP
- [NSSM - the Non-Sucking Service Manager](https://nssm.cc/download)
    - `nssm install 服務名稱 "路徑"`
    - `nssm start 服務名稱`

# [Run a self-hosted agent behind a web proxy](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/proxy?view=azure-devops&tabs=windows)
- Linux: `./config.sh --proxyurl http://10.248.15.7:3128`
- Windows: `./config.cmd --proxyurl http://10.248.15.7:3128`