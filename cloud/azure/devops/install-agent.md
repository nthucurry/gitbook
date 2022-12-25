- [參考](#參考)
- [Self-Hosted Agent](#self-hosted-agent)
  - [流程](#流程)
  - [Self-hosted Linux agents](#self-hosted-linux-agents)
  - [Windows Agent](#windows-agent)
  - [Run a self-hosted agent behind a web proxy](#run-a-self-hosted-agent-behind-a-web-proxy)
- [Pipeline Variables](#pipeline-variables)

# 參考
- [Day19 Azure Pipelines服務 YAML 說明與設定](https://ithelp.ithome.com.tw/articles/10239784)

# Self-Hosted Agent
## 流程
<br><img src="https://i0.wp.com/torbenp.com/wp-content/uploads/2020/07/BlazorAppOnArm.png?w=1168&ssl=1" width=500 board="1">
<br><img src="https://i0.wp.com/torbenp.com/wp-content/uploads/2020/07/adoci-2.png" width=500 board="1">

## [Self-hosted Linux agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops)
- 取得 PAT
    - [Authenticate with a personal access token (PAT)](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops#authenticate-with-a-personal-access-token-pat)
- 安裝
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
    # 請輸入 代理程式集區 (請為 default 按 Enter) > Linux (要先在 DevOps Portal 新增 Agent Pool)
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
- 重裝服務
    ```bash
    sudo ./svc.sh stop
    sudo ./svc.sh uninstall
    ./config.sh remove
    ./config.sh
    sudo ./svc.sh install azadmin
    sudo ./svc.sh start
    sudo ./svc.sh status
    ```
- 必要套件
    - git
        ```bash
        sudo yum install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
        sudo yum install git -y
        git config --global credential.helper store
        ```
    - docker
        ```bash
        sudo yum update -y
        sudo yum install yum-utils device-mapper-persistent-data lvm2 -y
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install docker-ce -y
        sudo usermod -aG docker $USER
        sudo chmod 777 /var/run/docker.sock
        sudo systemctl enable docker --now
        ```
        - [proxy 設定請參考](/microservices/docker/docker.md)
        - `vi ~/.docker/config.json`
            ```json
            {
                "proxies":
                {
                    "default":
                    {
                        "httpProxy": "http://10.248.15.7:3128",
                        "httpsProxy": "http://10.248.15.7:3128",
                        "noProxy": "10.0.0.0/8,127.0.0.0/8"
                    }
                }
            }
            ```
    - nuget
        ```bash
        sudo yum install nuget -y
        ```
        - `vi ~/.nuget/Nuget/Nuget.conf`
            ```xml
            <?xml version="1.0" encoding="utf-8"?>
            <configuration>
                <config>
                    <add key="http_proxy" value="http://10.248.15.7:3128" />
                    <add key="https_proxy" value="http://10.248.15.7:3128" />
                </config>
                <packageSources>
                    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
                </packageSources>
            </configuration>
            ```
    - dotnet
    - wget
        ```bash
        # by root
        yum install gcc
        yum install gnutls-devel
        wget https://ftp.gnu.org/gnu/wget/wget-latest.tar.gz
        cd wget-1.21.3/
        ./configure
        make
        make install
        ln -s /usr/local/bin/wget /usr/bin/wget
        wget --help | head -3
        ```

## Windows Agent
- CMD
    - 類似 Linux SOP
- [NSSM - the Non-Sucking Service Manager](https://nssm.cc/download)
    - `nssm install 服務名稱 "路徑"`
    - `nssm start 服務名稱`

## [Run a self-hosted agent behind a web proxy](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/proxy?view=azure-devops&tabs=windows)
- Linux: `./config.sh --proxyurl http://10.248.15.7:3128`
- Windows: `./config.cmd --proxyurl http://10.248.15.7:3128`

# Pipeline Variables
- Build.DefinitionName: The name of the build pipeline (Project)
- Build.TriggeredBy.ProjectID
- System.CollectionUri: https://dev.azure.com/xxx
- System.TeamProjectId