# Install SOP
- os initital-install
    ```bash
    wget https://storagedbak8s.blob.core.windows.net/for-ibm/dataplatform-ap.zip
    wget https://storagedbak8s.blob.core.windows.net/for-ibm/dataplatform-db.zip

    sudo vi /etc/sysctl.conf
    # vm.max_map_count=655360
    sudo sysctl -p
    ```
- docker
    ```bash
    # Install Docker Engine on Ubuntu
    ## Set up the repository
    apt install zip
    apt install net-tools
    apt-get update -y
    apt-get install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    ## Install Docker Engine (latest version)
    apt-get update -y
    apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

    ## Post-installation steps for Linux
    # groupadd docker
    usermod -aG docker azadmin
    chmod 777 /var/run/docker.sock

    ## Configure Docker to start on boot
    systemctl enable docker.service --now
    systemctl enable containerd.service

    ##
    apt install docker-compose -y
    ```
- os post-install
    ```bash
    vi /etc/docker/daemon.json
    # {
    #     "log-driver": "json-file",
    #     "log-opts": {"max-size": "10m", "max-file": "3"}
    # }
    systemctl reload docker
    ```
- docker login
    ```bash
    docker login xxx.azurecr.io
    ```
- node red (DB)
    ```bash
    tar zxvf docker_v5.tar.gz
    docker-compose -f docker-compose-db.yml up -d
    curl 10.1.0.10:9200
    ./docker/init.sh
    curl 10.1.0.10:9200/_cat/health?v
    ```
- node red (AP)
    ```bash
    tar zxvf docker_v5.tar.gz
    tar zxvf iradmin_v5.tar.gz
    docker-compose -f docker-compose-ap.yml up -d
    ```