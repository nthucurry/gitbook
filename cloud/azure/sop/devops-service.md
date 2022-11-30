- [參考](#參考)
- [Self-Hosted Agent](#self-hosted-agent)
  - [流程](#流程)
  - [Self-hosted Linux agents](#self-hosted-linux-agents)
  - [Windows Agent](#windows-agent)
  - [Run a self-hosted agent behind a web proxy](#run-a-self-hosted-agent-behind-a-web-proxy)
- [Pipeline Variables](#pipeline-variables)
- [Choose the right authentication mechanism](#choose-the-right-authentication-mechanism)
  - [Authenticate with PATs](#authenticate-with-pats)
  - [Authenticate with OAuth 2.0 (略)](#authenticate-with-oauth-20-略)
- [客製化](#客製化)
  - [OS Requirement](#os-requirement)
  - [Pipeline (CI/CD)](#pipeline-cicd)
  - [推送 Template 到其他的 Repo](#推送-template-到其他的-repo)

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

# [Choose the right authentication mechanism](https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/authentication-guidance?view=azure-devops)
> The Azure DevOps API doesn't support non-interactive service access via **service principals** yet, although it is on the roadmap.
> If you need to call the Azure DevOps API from a non-interactive application (where an end user cannot authenticate interactively, such as a background job), it should use a **personal access token (PAT)**.
- [Projects - List](https://learn.microsoft.com/en-us/rest/api/azure/devops/core/projects/list?view=azure-devops-rest-6.0&tabs=HTTP)
    ```bash
    organization=xxx
    userName=xxx
    pat=xxx
    curl --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects?api-version=6.0 \
        -u ${userName}:${pat} | jq '.value[].name'
    ```
- Teams - Get All Teams
    ```bash
    organization=xxx
    userName=xxx
    pat=xxx
    curl --location \
        --request GET https://dev.azure.com/${organization}/_apis/teams?api-version=6.0-preview.3 \
        -u ${userName}:${pat} | jq '.value[].projectName'
    ```
- Teams - Get Team Members With Extended Properties
    ```bash
    organization=xxx
    userName=xxx
    pat=xxx
    curl --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects/0fef353f-204f-4058-97c9-61bdcf64954a/teams/386438bf-71d4-43ac-b9ea-6457ce88c4d8/members?api-version=6.0 \
        -u ${userName}:${pat}
    ```
- Groups - List
    ```bash
    organization=xxx
    userName=xxx
    pat=xxx
    curl --location \
        --request GET 'https://vssps.dev.azure.com/${organization}/_apis/graph/groups?api-version=5.0-preview.1' \
        -u ${userName}:${pat} | jq '.value[].displayName'
    curl --location \
        --request GET 'https://vssps.dev.azure.com/${organization}/_apis/graph/groups?api-version=5.0-preview.1' \
        -u ${userName}:${pat} | jq '.value[].descriptor'
    ```

## Authenticate with PATs
- [Can I use basic auth with all Azure DevOps REST APIs?](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?toc=%2Fazure%2Fdevops%2Fmarketplace-extensibility%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fmarketplace-extensibility%2Fbreadcrumb%2Ftoc.json&view=azure-devops&tabs=Windows#q-can-i-use-basic-auth-with-all-azure-devops-rest-apis)
    - No. You can use basic auth with most Azure DevOps REST APIs, but **organizations** and **profiles** only support OAuth. For more information, see Manage PATs using REST API.

## Authenticate with OAuth 2.0 (略)

# 客製化
## OS Requirement
```bash
sudo su
yum install gcc # gcc-4.8.5-44.el7.x86_64
yum install gnutls-devel # gnutls-devel-3.3.29-9.el7_6.x86_64
wget https://ftp.gnu.org/gnu/wget/wget-latest.tar.gz
tar zxvf wget-latest.tar.gz
cd wget-1.21.3/
./configure
make
make install
cp /root/wget-1.21.3/src/wget /bin
wget --help | head -3
```

## Pipeline (CI/CD)
- 跑完後 Mail 通知: `sendMail.sh`
    ```bash
    #!/bin/bash

    codePath="/home/azadmin/mail-relay"
    reportPath="/home/azadmin/report"

    # Azure DevOps
    organization=`echo $1 | awk -F \/ '{print $4}'`
    projectId=$2
    mail=$3
    userName="xxx"
    pat="xxx"
    teamId=`curl \
      --location \
      --request GET https://dev.azure.com/${organization}/_apis/projects/${projectId}/teams?api-version=6.0 \
      --user ${userName}:${pat} | jq '.value[].id' | sed 's/"//g'`
    projectName=`curl \
      --location \
      --request GET https://dev.azure.com/${organization}/_apis/projects/${projectId}/teams?api-version=6.0 \
      --user ${userName}:${pat} | jq '.value[].projectName' | sed 's/"//g'`
    descriptor=`curl \
      --location \
      --request GET https://vssps.dev.azure.com/${organization}/_apis/graph/groups?api-version=5.0-preview.1 \
      --user ${userName}:${pat} | jq '.value[] | select((.displayName == "Contributors") and (.principalName | contains("SOP"))) | .    descriptor' | sed 's/"//g'`
    #mail=`curl \
    #  --location \
    #  --request GET https://dev.azure.com/${organization}/_apis/projects/${projectId}/teams/${teamId}/members?api-version=7.1-preview.1 \
    #  --user ${userName}:${pat} | jq '.value[].uniqueName' | sed 's/"//g'`

    # Mend
    requestType="getProjectRiskReport"
    userKey="xxx"
    echo "jq '.ast[] | select((.devOps.organization == \"${organization}\") and (.mend.projectName == \"${projectName}\")) | .mend.    projectToken' ${codePath}/astConfig.json" > ${codePath}/checkASTConfig.sh
    projectToken=`${codePath}/checkASTConfig.sh | sed 's/"//g'`
    project=`echo ${projectName} | sed 's/\s/-/g'`
    mendReport="mend_${organization}_${project}_${requestType}.pdf"
    echo "curl \
      -o ${reportPath}/${mendReport} \
      --location \
      --request POST 'https://app.whitesourcesoftware.com/api/v1.3' \
      --header 'Content-Type: application/json' \
      --data '{
        "requestType": "${requestType}",
        "userKey": "${userKey}",
        "projectToken": "${projectToken}"
      }'" > ${codePath}/getMendReport.sh
    ${codePath}/getMendReport.sh

    # Checkmarx

    # Output
    echo `date` > ${codePath}/123.txt
    echo "${codePath}/sendMail.sh $1 $2 $3" >> ${codePath}/123.txt
    echo "DevOps:" >> ${codePath}/123.txt
    echo "  organization: ${organization}" >> ${codePath}/123.txt
    echo "  projectName: ${projectName}" >> ${codePath}/123.txt
    echo "  descriptor: ${descriptor}" >> ${codePath}/123.txt
    echo "  mail: ${mail}" >> ${codePath}/123.txt
    echo "Mend:" >> ${codePath}/123.txt
    echo "  project: ${project}" >> ${codePath}/123.txt
    echo "  mendReport: ${mendReport}" >> ${codePath}/123.txt

    # Mail
    ${codePath}/execMailRelay.sh ${mail} ${mendReport}

    echo "Mail:" >> ${codePath}/123.txt
    echo "  ${codePath}/execMailRelay.sh ${mail} ${mendReport}" >> ${codePath}/123.txt
    ```
- 發 Mail Script: `execMailRelay.sh`
    ```bash
    #!/bin/bash

    codePath="/home/azadmin/mail-relay"
    reportPath="/home/azadmin/report"
    requestType="getProjectRiskReport"
    mailRelay="au3mr1.corpnet.auo.com"
    #account=`echo -n "apikey" | base64`
    #password=`echo -n "SG.xxx" | base64`
    sender="DBAAlert@auo.com"
    recipient=$1
    fileName=$2
    project=`echo ${fileName} | awk -F _ '{print $3}' | sed 's/-/ /g'`
    subject=`cat ${codePath}/mailSubject.txt`
    subject+=`echo ${project}`

    {
    #sleep 1;
    echo "EHLO ${mailRelay}"
    sleep 1;
    echo "MAIL FROM:<${sender}>"
    sleep 1;
    echo "RCPT TO:<${recipient}>"
    echo "RCPT TO:<tony.lee@auo.com>"
    sleep 1;
    echo "DATA"
    sleep 1;
    echo "Subject:" ${subject}
    sleep 1;
    echo "MIME-Version: 1.0"
    sleep 1;
    echo "Content-Type: multipart/mixed; boundary=\"KkK170891tpbkKk__FV_KKKkkkjjwq\""
    sleep 1;
    #echo ""
    sleep 1;
    echo "--KkK170891tpbkKk__FV_KKKkkkjjwq"
    sleep 1;
    echo "Content-Type:application/octet-stream;name=\"${reportPath}/${fileName}\""
    echo "Content-Transfer-Encoding:base64"
    echo "Content-Disposition:attachment;filename=\"${fileName}\""
    sleep 1;
    echo ""
    sleep 1;
    sleep 1;
    sleep 1;
    sleep 1;
    sleep 1;
    sleep 1;
    echo ""
    sleep 1;
    # The content is encoded in base64.
    cat ${reportPath}/${fileName} | base64;
    sleep 1;
    #echo ""
    sleep 1;
    #echo ""
    sleep 1;
    echo "--KkK170891tpbkKk__FV_KKKkkkjjwq--"
    sleep 1;
    #echo ""
    sleep 1;
    echo "."
    sleep 1;
    echo "quit"
    } | telnet ${mailRelay} 25
    ```
- 設定檔
    ```json
    {
      "ast": [
        {
          "devOps": {
            "organization": "abc-abc"
          },
          "mend": {
            "projectName": "abc",
            "projectToken": "abc"
          },
          "checkmarx": {}
        },
        {
          "devOps": {
            "organization": "xyz-xyz"
          },
          "mend": {
            "projectName": "xyz",
            "projectToken": "xyz"
          },
          "checkmarx": {}
        }
      ]
    }
    ```
- YAML Pipeline
    ```yaml
    pool:
      name: Linux

    steps:
    - task: Bash@3
      inputs:
        filePath: '/home/azadmin/mail-relay/sendMail.sh'
        arguments: '$(System.CollectionUri) $(System.TeamProjectId) $(Build.RequestedForEmail)'
    ```

## 推送 Template 到其他的 Repo
```bash
#!/bin/bash

# 推送 template 到其他的 repo (for new project)
organization="aaa"
project="bbb"
git remote add ${organization}_${project} https://${organization}@dev.azure.com/${organization}/${project}/_git/${project}
git remote -v
git push -u ${organization}_${project} --all

# git remote remove aaa_bbb
# git push -u origin --all
# git push -u repo1 --all
# git push -u repo2 --all
```