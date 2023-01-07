# [Mounting cloud object storage on Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/dbfs/mounts)
- https://learn.microsoft.com/en-us/azure/databricks/dbfs/mounts
- 掛載 Storage
    - 建立 Service Principal
        - 記下 value
        - [授予 SP Storage Blob Data Contributor 權限](https://learn.microsoft.com/en-us/azure/databricks/security/aad-storage-service-principal#assign-roles)
    - 使用 Databricks-backed secret scope，前置作業為：
        - Linux VM
        - 安裝 python3
        - 安裝 pip
            - `yum install python3-pip -y`
        - 安裝 databricks-cli
            - `pip3 install databricks-cli --upgrade`
    - 建立 databricks token
        - [到 Databricks Portal 設定 PAT](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#--azure-databricks-personal-access-tokens)
        - 記下 token
        - 確認 token
            - `databricks configure --token`
                ```
                Databricks Host (should begin with https://): https://xxx.azuredatabricks.net
                Token: xxx
                ```
            - `databricks secrets list-scopes`
                ```
                Scope    Backend    KeyVault URL
                -------  ---------  --------------
                ```
    - 建立 databricks secret scope
        - `vi create-scope.json` (key: screte scope 密碼)
            ```json=
            {
                "scope": "mount-storage-scope",
                "initial_manage_principal": "users"
            }
            ```
        - create secret scope
            ```bash!
            DATABRICKS_TOKEN="xxx"
            curl --request POST --header "Authorization: Bearer ${DATABRICKS_TOKEN}" https://xxx.azuredatabricks.net/api/2.0/secrets/scopes/create --data @create-scope.json
            ```
    - 檢查 secrets
        - `databricks secrets list-scopes`
            ```
            Scope    Backend    KeyVault URL
            -------------------  ----------  --------------
            mount-storage-scope  DATABRICKS  N/A
            ```
    - Put databricks secret scope
        - vi put-secret.json (string_value: SP value)
            ```json=
            {
                "scope": "mount-storage-scope",
                "key": "abc123",
                "string_value": "xxx~xxx~xxx-xxx"
            }
            ```
        - put
            ```bash!
            DATABRICKS_TOKEN="xxx"
            curl --request POST --header "Authorization: Bearer ${DATABRICKS_TOKEN}" https://xxx.azuredatabricks.net/api/2.0/secrets/put --data @put-secret.json
            ```
    - 到 databricks notebook 確認 secret scope list
        - `dbutils.secrets.listScopes()`
        - `dbutils.secrets.get(scope="my-simple-databricks-scope",key="sdoijsjoi443f")`
            - Out[2]: '[REDACTED]'
        - `dbutils.secrets.list(scope="my-simple-databricks-scope")`
            - Out[3]: [SecretMetadata(key='abc123')]
    - 掛載 storage
        ```python=
        directory_id = "xxx-xxx-xxx-xxx-xxx"
        application_id = "xxx-xxx-xxx-xxx-xxx"
        value = "xxx~xxx~xxx-xxx"
        storage_account = "xxx"
        container_name = "xxx"
        configs = {"fs.azure.account.auth.type": "OAuth",
                  "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
                  "fs.azure.account.oauth2.client.id": application_id,
                  "fs.azure.account.oauth2.client.secret": dbutils.secrets.get(scope="mount-storage-scope",key="abc123"),
                  "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/" + directory_id + "/oauth2/token"}

        # Optionally, you can add <directory-name> to the source URI of your mount point.
        dbutils.fs.mount(
          source = "abfss://" + container_name + "@" + storage_account + ".dfs.core.windows.net/",
          mount_point = "/mnt/" + container_name,
          extra_configs = configs)
        ```
    - 確認掛載狀態
        - `%sh ls /dbfs/mnt/xxx`
- 卸載 storage
    ```python=
    container_name = "xxx"
    dbutils.fs.unmount("/mnt/" + container_name)
    # /mnt/xxx has been unmounted.
    # Out[3]: True
    ```
- Check all mount points
    ```python
    dbutils.fs.mounts()
    ```