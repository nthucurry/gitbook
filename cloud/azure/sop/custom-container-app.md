# [Configure a custom container for Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux)
- [Enable SSH](https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh)
    - Dockerfile
        ```Dockerfile
        # Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
        RUN apk add openssh \
            && echo "root:Docker!" | chpasswd

        # Copy the sshd_config file to the /etc/ssh/ directory
        COPY sshd_config /etc/ssh/

        # Copy and configure the ssh_setup file
        RUN mkdir -p /tmp
        COPY ssh_setup.sh /tmp
        RUN chmod +x /tmp/ssh_setup.sh \
            && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

        # Open port 2222 for SSH access
        EXPOSE 80 2222
        ```

# [Mount Azure Storage as a local share in App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage?tabs=portal&pivots=container-linux)
- Prerequisites
    - App Service on Linux app.
    - Azure file share and directory.
- Limitations
    - Azure Storage is not supported with Docker Compose Scenarios.
    - Only Azure Files SMB are supported.
    - Azure Files NFS is not currently supported for Linux App Services.
- Mount storage to Linux container
    - Configuration options
        - Select **Basic** if the storage account is **not** using service endpoints or private endpoints.
        - Otherwise, select **Advanced**.
- Test the mounted storage
    - https://<app_service_name>.scm.azurewebsites.net/newui/webssh
    - `df -h`