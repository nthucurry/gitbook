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