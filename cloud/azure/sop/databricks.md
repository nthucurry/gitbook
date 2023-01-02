# [Mounting cloud object storage on Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/dbfs/mounts)
- Create a Databricks-backed secret scope
    - Using the Databricks CLI (version 0.7.1 and above)
    - Alternatively, you can use the Secrets API 2.0
- Create a Databricks-backed secret scope
    ```bash
    pip install pip --upgrade
    pip install mlflow
    pip install databricks-cli --upgrade
    databricks -v
    databricks secrets create-scope --scope "test"
    ```
- Mount ADLS Gen2 or Blob Storage with ABFS (by Service Principal)
    ```python
    directory_id = ""
    application_id = ""
    # <scope-name> with the Databricks secret scope name.
    scope_name = ""
    # <service-credential-key-name> with the name of the key containing the client secret.
    service_credential_key_name = ""
    storage_account_name = ""
    container_name = ""
    mount_name = "gold"
    storage_account_name = "auoazibmadls"

    configs =
        {
            "fs.azure.account.auth.type": "OAuth",
            "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
            "fs.azure.account.oauth2.client.id": application_id,
            "fs.azure.account.oauth2.client.secret": dbutils.secrets.get(scope=scope_name, key=service_credential_key_name),
            "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/" + directory_id + "/oauth2/token"
        }

    # Optionally, you can add <directory-name> to the source URI of your mount point.
    dbutils.fs.mount(
    source = "abfss://" + container_name + "@" + <storage-account-name> + ".dfs.core.windows.net/",
    mount_point = "/mnt/" + mount_name,
    extra_configs = configs)
    ```
- Check all mount points
    ```python
    dbutils.fs.mounts()
    ```