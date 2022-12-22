# Access Azure Data Lake Storage Gen2 and Blob Storage
- How to access Azure storage containers using
    - Unity Catalog managed external locations
    - Azure service principals
    - SAS tokens
    - Account keys
- Using
    - a SAS token (Databricks Runtime 7.5 and above)
        ```python
        spark.conf.set("fs.azure.account.auth.type.auoazibmadls.dfs.core.windows.net", "SAS")
        spark.conf.set("fs.azure.sas.token.provider.type.auoazibmadls.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.sas.FixedSASTokenProvider")
        spark.conf.set("fs.azure.sas.fixed.token.auoazibmadls.dfs.core.windows.net", "<token>")
        ```
    - ABFS URI
        ```python
        spark.read.load("abfss://test@auoazibmadls.dfs.core.windows.net")
        dbutils.fs.ls("abfss://test@auoazibmadls.dfs.core.windows.net")
        ```
- Check all mount points
    ```python
    dbutils.fs.mounts()
    ```