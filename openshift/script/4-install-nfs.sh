sudo timedatectl set-timezone Asia/Taipei
sudo yum update -y | grep "Complete!"
sudo yum install epel-release -y | grep "Complete!"
sudo yum install nfs-utils -y "Complete!"
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
echo "/data *(rw,sync,no_root_squash)" | sudo tee /etc/exports
sudo systemctl restart nfs-server

# openshift client tool
cd ~
mkdir ocp4.5_client
cd ./ocp4.5_client
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.36/openshift-client-linux-4.5.36.tar.gz
tar xvfz openshift-client-linux-4.5.36.tar.gz
sudo cp ./oc /usr/bin

# K8S incubator
curl -L -o kubernetes-incubator.zip https://github.com/kubernetes-incubator/external-storage/archive/master.zip
unzip kubernetes-incubator.zip