sudo timedatectl set-timezone Asia/Taipei
sudo yum update -y | grep "Complete"
sudo yum install epel-release -y | grep "Complete"
sudo yum install htop telnet nc nmap -y | grep "Complete"
sudo yum install nfs-utils -y | grep "Complete"
sudo yum install expect -y | grep "Complete"

# replace redhad docker tool
sudo yum install podman -y | grep "Complete"

# azure cli
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo yum install azure-cli -y | grep "Complete"

# openshift install package
cd ~
mkdir ocp4.5_inst
cd ~/ocp4.5_inst
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-install-linux-4.5.36.tar.gz
tar xvf openshift-install-linux-4.5.36.tar.gz

# openshift install config
cd ~
mkdir ocp4.5_cust
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/openshift/config/install-config.yaml

# generate ssh key
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y
ssh_key_values="`cat ~/.ssh/id_rsa.pub`"

# update ssh key in install-config.yaml
sed -i "s|ssh-rsa XXXX|$ssh_key_values|g" ~/install-config.yaml
mv ~/install-config.yaml ~/ocp4.5_cust
ln -s ~/ocp4.5_cust/install-config.yaml

# openshift client tool
cd ~
mkdir ocp4.6_client
cd ~/ocp4.6_client
# wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.6.56/openshift-client-linux-4.6.56.tar.gz
tar xvfz openshift-client-linux-4.6.56.tar.gz
sudo cp ~/oc /usr/bin

# openshift tab completion
oc completion bash > oc_bash_completion
sudo cp oc_bash_completion /etc/bash_completion.d/

# download useful script
cd ~
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/openshift/script-backup/backup-etcd.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/openshift/script-maintain/check-pod.sh
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/openshift/script/login-ocp.sh
chmod +x backup-etcd.sh check-pod.sh login-ocp.sh

# download ocp install script
cd ~
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/openshift/script/2-azure-config.exp
wget https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/microservices/openshift/script/3-install-ocp.sh
chmod +x 2-azure-config.exp 3-install-ocp.sh