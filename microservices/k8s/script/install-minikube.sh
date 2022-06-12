#/bin/bash

echo ".... Initial OS ...."
echo "  1. Environment value"
    LANG=en_US.UTF-8
    swapoff -a
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
    timedatectl set-timezone Asia/Taipei


echo "  2. Update OS"
    yum update -y | grep "Complete"
    yum install epel-release -y | grep "Complete"
    yum install htop -y | grep "Complete"
    yum install telnet -y | grep "Complete"
    yum install yum-utils device-mapper-persistent-data lvm2 -y | grep "Complete"
    yum install traceroute -y | grep "Complete"
    yum install nc -y | grep "Complete"
    yum install nmap -y | grep "Complete"
    yum install git -y | grep "Complete"
    echo -e


echo ".... Install Docker ...."
echo "  1. Add the Docker repository"
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo


echo "  2. Install Docker CE"
    yum install docker-ce -y | grep "Complete"
    # yum install containerd.io docker-ce docker-ce-cli -y | grep "Complete"
    # echo "==== If necessary, remove it"
    # yum remove containerd.io; yum remove docker


echo "  3. Set up the Docker daemon"
echo "  4. Start docker"
    systemctl daemon-reload
    systemctl enable docker --now
    # docker run hello-world
    # docker ps -a
    # exit


echo ".... Install Minikube ...."
echo "  1. Letting iptables see bridged traffic"
echo "  2. Set SELinux in permissive mode (effectively disabling it)"
    setenforce 0
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
    echo -e


echo "  3. Installing kubectl (DO NOT CONFIG exclude=kubelet kubeadm kubectl)"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
    rpm -ivh minikube-latest.x86_64.rpm
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    cp ./kubectl /usr/local/bin
    kubectl completion bash | tee -a /etc/bash_completion.d/kubectl > /dev/null
    echo -e


echo "  4. Install CRI-O (lightweight container runtime for kubernetes)"
echo "  5. Pull the images for kubeadm requires"
echo "  6. Start Minikube"
    minikube start --driver=docker
    echo -e


echo "  7. Set up autocomplete"
    USER=azadmin
    echo "source <(kubectl completion bash)" >> /home/$USER/.bashrc
    echo "alias k=kubectl" >> /home/$USER/.bashrc
    echo "complete -F __start_kubectl k" >> /home/$USER/.bashrc


echo ".... Check status ...."
    systemctl status docker
    echo -e
    minikube status
    echo -e
    minikube dashboard