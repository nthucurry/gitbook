# Linux
- Portal
    - 取 token
- CMD
    ```bash
    wget https://vstsagentpackage.azureedge.net/agent/2.204.0/vsts-agent-linux-x64-2.204.0.tar.gz
    mkdir myagent
    mv vsts-agent-linux-x64-2.204.0.tar.gz myagent/
    cd myagent
    tar zxvf vsts-agent-linux-x64-2.204.0.tar.gz
    ./config.sh
    # 請輸入 (Y/N) 現在就接受 Team Explorer Everywhere 授權合約嗎?  (請為 否 按 Enter) > 按 Enter
    # 請輸入 伺服器 URL > https://dev.azure.com/AUOSecScan
    # 請輸入 驗證類型 (請為 PAT 按 Enter) > 按 Enter
    # 請輸入 個人存取權杖 > ****************************************************
    # 請輸入 代理程式集區 (請為 default 按 Enter) > Linux Agent
    # 請輸入 代理程式名稱 (請為 t-dol 按 Enter) > 按 Enter
    # 請輸入 工作資料夾 (請為 _work 按 Enter) > 按 Enter
    sudo ./bin/installdependencies.sh
    ./run.sh
    ```
- [Run as a systemd service](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops-2020#run-as-a-systemd-service)

# Windows

# [Run a self-hosted agent behind a web proxy](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/proxy?view=azure-devops&tabs=windows)
- Linux: `./config.sh --proxyurl http://10.248.15.7:3128`
- Windows: `./config.cmd --proxyurl http://10.248.15.7:3128`