sudo timedatectl set-timezone Asia/Taipei
sudo yum update -y
sudo yum install epel-release -y
sudo yum install htop telnet nc nmap -y
sudo yum install nfs-utils -y
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# ssh
ssh-keygen

# azure cli
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo yum install azure-cli -y

# openshift install package
cd ~
mkdir ocp4.5_inst
cd ./ocp4.5_inst
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-install-linux-4.5.36.tar.gz
tar xvf openshift-install-linux-4.5.36.tar.gz

# openshift install config
cd ~
mkdir ocp4.5_cust
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/knowledge/infra/openshift/install-config.yaml
cp ./install-config.yaml ./ocp4.5_cust

# openshift tool
cd ~
mkdir ocp4.5_client
cd ./ocp4.5_client
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
tar xvfz openshift-client-linux-4.5.36.tar.gz
sudo cp ./oc /usr/bin

# openshift tab completion
oc completion bash > oc_bash_completion
sudo cp oc_bash_completion /etc/bash_completion.d/