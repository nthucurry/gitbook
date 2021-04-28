#/bin/bash

# 1. Install Docker CE
echo "==== Install Docker CE"
## Set up the repository
### Install required packages
yum install yum-utils device-mapper-persistent-data lvm2 -y

# 2. Add the Docker repository
echo "==== Add the Docker repository"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 3. Install Docker CE
echo "==== Install Docker CE"
# yum install containerd.io-1.2.13 docker-ce-19.03.11 docker-ce-cli-19.03.11 -y
yum install containerd.io docker-ce docker-ce-cli -y
# echo "==== If necessary, remove it"
# yum remove containerd.io && yum remove docker

## Create /etc/docker
echo "==== Create /etc/docker"
mkdir /etc/docker

# 4. Set up the Docker daemon
echo "==== Set up the Docker daemon"
cat << EOF | tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check=true"
    ]
}
EOF

# 5. Create /etc/systemd/system/docker.service.d
# echo "==== Create /etc/systemd/system/docker.service.d"
# mkdir -p /etc/systemd/system/docker.service.d

# 6. Restart Docker
echo "==== Restart Docker"
systemctl daemon-reload
systemctl restart docker
systemctl enable docker