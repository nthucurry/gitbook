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
  - [Pipeline (CI/CD)](#pipeline-cicd)
  - [推送 Ｔemplate 到其他的 Ｒepo](#推送-ｔemplate-到其他的-ｒepo)

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
    username=xxx
    pat=xxx
    curl --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects?api-version=6.0 \
        -u $username:$pat | jq '.value[].name'
    ```
- Teams - Get All Teams
    ```bash
    organization=xxx
    username=xxx
    pat=xxx
    curl --location \
        --request GET https://dev.azure.com/${organization}/_apis/teams?api-version=6.0-preview.3 \
        -u $username:$pat | jq '.value[].projectName'
    ```
- Teams - Get Team Members With Extended Properties
    ```bash
    organization=xxx
    username=xxx
    pat=xxx
    curl --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects/0fef353f-204f-4058-97c9-61bdcf64954a/teams/386438bf-71d4-43ac-b9ea-6457ce88c4d8/members?api-version=6.0 \
        -u $username:$pat
    ```

## Authenticate with PATs
- [Can I use basic auth with all Azure DevOps REST APIs?](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?toc=%2Fazure%2Fdevops%2Fmarketplace-extensibility%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fmarketplace-extensibility%2Fbreadcrumb%2Ftoc.json&view=azure-devops&tabs=Windows#q-can-i-use-basic-auth-with-all-azure-devops-rest-apis)
    - No. You can use basic auth with most Azure DevOps REST APIs, but **organizations** and **profiles** only support OAuth. For more information, see Manage PATs using REST API.

## Authenticate with OAuth 2.0 (略)

# 客製化
## Pipeline (CI/CD)
- 跑完後 Mail 通知: `sendMail.sh`
    ```bash
    #!/bin/bash

    codePath="/home/azadmin"
    reportPath="/home/azadmin"

    # Azure DevOps
    organization=`echo $1 | awk -F \/ '{print $4}'`
    projectId=$2
    userName="xxx"
    pat="xxx"
    teamId=`curl \
        --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects/${projectId}/teams?api-version=6.0 \
        --user $userName:$pat | jq '.value[].id' | sed 's/"//g'`
    projectName=`curl \
        --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects/${projectId}/teams?api-version=6.0 \
        --user $userName:$pat | jq '.value[].projectName' | sed 's/"//g'`
    mail=`curl \
        --location \
        --request GET https://dev.azure.com/${organization}/_apis/projects/${projectId}/teams/${teamId}/members?api-version=7.1-preview.1 \
        --user ${userName}:${pat} | jq '.value[].uniqueName' | sed 's/"//g'`

    # Mend
    echo "jq "\'.ast[].devOps.organization == \"${organization}\"\'" ${codePath}/astConfig.json" > ${codePath}/checkASTConfig.sh
    isOrganizationExistOnMend=`${codePath}/checkASTConfig.sh`
    echo "jq "\'.ast[].mend.projectName == \"${projectName}\"\'" ${codePath}/astConfig.json" > ${codePath}/checkASTConfig.sh
    isProjectNameExistOnMend=`${codePath}/checkASTConfig.sh`
    [[ ${isOrganizationExistOnMend} == ${isProjectNameExistOnMend} ]] && isExistOnMend=true || isExistOnMend=false
    requestType="getProjectRiskReport"
    userKey="xxx"
    if [[ ${isExistOnMend} ]]; then
        projectToken=`jq '.ast[].mend.projectToken' ${codePath}/astConfig.json | sed 's/"//g'`
        project=`echo ${projectName} | sed 's/\s//g'`
        echo "curl \
            -o ${reportPath}/mend-${organization}_${project}-${requestType}.pdf \
            --location \
            --request POST 'https://app.whitesourcesoftware.com/api/v1.3' \
            --header 'Content-Type: application/json' \
            --data '{
                "requestType": "${requestType}",
                "userKey": "${userKey}",
                "projectToken": "${projectToken}"
            }'" > ${codePath}/getMendReport.sh
        ${codePath}/getMendReport.sh
    fi

    # Checkmarx

    # Mail
    ${codePath}/updateMailScript.sh ${mail}
    ```
- 發 Mail Script: `updateMailScript.sh`
    ```bash
    #!/bin/bash

    codePath="/home/azadmin/mail-relay"
    requestType="getProjectRiskReport"
    mailRelay="smtp.sendgrid.net"
    account=`echo -n "apikey" | base64`
    password=`echo -n "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" | base64`
    sender="xxx@xxx.xxx"
    recipient=$1
    expFile="${codePath}/sendMail.exp"

    cat << EOF | tee ${expFile}
    #!/usr/bin/expect -f
    spawn /usr/bin/telnet ${mailRelay} 587
    expect "220 ${mailRelay} ESMTP Postfix"
    send "EHLO ${mailRelay}\r"
    expect "250 DNS"
    send "AUTH LOGIN"
    expect "334 VXNlcm5hbWU6"
    send "${account}"
    expect "334 UGFzc3dvcmQ6"
    send "${password}"
    send "MAIL FROM: ${sender}\r"
    expect "250 2.1.0 Ok"
    send "RCPT TO: ${recipient}\r"
    expect "250 2.1.5 Ok"
    send "DATA\r"
    expect "354 End data with <CR><LF>.<CR><LF>"
    send "Subject: Pipeline Result\r"
    send "MIME-Version: 1.0\r"
    send "Content-Type:multipart/mixed;boundary=\"KkK170891tpbkKk__FV_KKKkkkjjwq\"\r"
    send "--KkK170891tpbkKk__FV_KKKkkkjjwq\r"
    send "Content-Type:application/octet-stream;name=\"${codePath}/mend-${requestType}.pdf\"\r"
    send "Content-Transfer-Encoding:base64\r"
    send "Content-Disposition:attachment;filename=\"${codePath}/mend-${requestType}.pdf\"\r"
    send "--KkK170891tpbkKk__FV_KKKkkkjjwq--\r"
    send ".\r"
    expect "250 2.0.0 Ok: queued as E73FDE07B6"
    send "quit\r"
    EOF

    chmod +x ${expFile}
    ${expFile}
    ```
    ```bash
    #!/bin/bash

    filename="/home/azadmin/123.txt"
    mailRelay="smtp.sendgrid.net"
    sender="xxx@xxx.xxx"
    recipient=$1
    subject="Subject of my email"
    txtmessage="This is the message I want to send"

    {
    sleep 1;
    echo "EHLO ${mailRelay}"
    sleep 1;
    echo "AUTH LOGIN"
    sleep 1;
    echo "YXBpa2V5"
    sleep 1;
    echo "U0cuNWk3cUJXUU9UNXFTbzNGaUxEQ3Q2QS5JYXhtTTRaZWNXQS1IX2U2a2Q0UXBfS1p3RDVFakFs eWhTYnYzN1U4dWZ3"
    sleep 1;
    echo "MAIL FROM:${sender}"
    sleep 1;
    echo "RCPT TO:${recipient}"
    sleep 1;
    echo "DATA"
    sleep 1;
    echo "Subject:" ${subject}
    sleep 1;
    echo "Content-Type: multipart/mixed; boundary="KkK170891tpbkKk__FV_KKKkkkjjwq""
    sleep 1;
    echo ""
    sleep 1;
    echo "This is a MIME formatted message.  If you see this text it means that your"
    sleep 1;
    echo "email software does not support MIME formatted messages."
    sleep 1;
    echo ""
    sleep 1;
    echo "--KkK170891tpbkKk__FV_KKKkkkjjwq"
    sleep 1;
    echo "Content-Type: text/plain; charset=UTF-8; format=flowed"
    sleep 1;
    echo "Content-Disposition: inline"
    sleep 1;
    echo ""
    sleep 1;
    echo ${txtmessage}
    sleep 1;
    echo ""
    sleep 1;
    echo ""
    sleep 1;
    echo "--KkK170891tpbkKk__FV_KKKkkkjjwq"
    sleep 1;
    echo "Content-Type: file --mime-type -b filename-$(date +%y%m%d).zip; name=filename-$(date +%y%m%d).zip"
    sleep 1;
    echo "Content-Transfer-Encoding: base64"
    sleep 1;
    echo "Content-Disposition: attachment; filename="filename-$(date +%y%m%d).zip";"
    sleep 1;
    echo ""
    sleep 1;
    # The content is encoded in base64.
    cat ${filename} | base64;
    sleep 1;
    echo ""
    sleep 1;
    echo ""
    sleep 1;
    echo "--KkK170891tpbkKk__FV_KKKkkkjjwq--"
    sleep 1;
    echo ""
    sleep 1;
    echo "."
    sleep 1;
    echo "quit"
    } | telnet ${mailRelay} 25
    ```
- YAML Pipeline
    ```yaml
    pool:
      name: Linux

    steps:
    - task: Bash@3
      inputs:
        filePath: '/home/azadmin/mail-relay/sendMail.sh'
        arguments: '$(System.CollectionUri) $(System.TeamProjectId)'
    ```

## 推送 Ｔemplate 到其他的 Ｒepo
```bash
#!/bin/bash

# 推送 template 到其他的 repo (for new project)
oragniation="aaa"
project="bbb"
git remote add ${oragniation}_${project} https://${oragniation}@dev.azure.com/${oragniation}/${project}/_git/${project}
git remote -v
git push -u ${oragniation}_${project} --all

# git remote remove aaa_bbb
# git push -u origin --all
# git push -u repo1 --all
# git push -u repo2 --all
```