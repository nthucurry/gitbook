- [Proxy on Network Env.](#proxy-on-network-env)
- [Script on VM](#script-on-vm)
- [Azure DevOps](#azure-devops)

# Proxy on Network Env.
- .gitconfig
    ```
    [alias]
        co = checkout
        br = branch
        st = status
        ci = commit
    [user]
        name = test
        email = test@example.com
    [http]
        proxy = http://squid:3128
        sslBackend = schannel
        postBuffer = 524288000
    [credential]
        helper = store
    ```

# Script on VM
- gitPullCode.sh
    ```bash
    #!/bin/bash

    configPath="/home/azadmin/config/SOP"
    HOME="/home/azadmin"
    organization="xxx"

    echo `date` > ${HOME}/456.txt
    cd ${configPath}
    git pull >> ${HOME}/456.txt
    ```

# Azure DevOps
- azure-pipelines.yml
    ```yaml
    # trigger:
    # - master

    pool:
    name: Linux

    steps:
    - task: Bash@3
    inputs:
        filePath: '/home/azadmin/config/gitPullCode.sh'
    ```