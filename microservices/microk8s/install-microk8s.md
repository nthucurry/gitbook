- Update Server and Install Snap
    ```bash
    sudo yum install epel-release -y
    sudo yum update -y
    sudo yum install snapd -y
    sudo systemctl enable snapd.socket --now
    sudo ln -s /var/lib/snapd/snap /snap
    ```
- Disable SELinux
    ```bash
    sudo setenforce 0
    sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
    ```
- Ensure snap’s paths are updated correctly
    ```bash
    sudo ln -s /var/lib/snapd/snap /snap
    echo 'export PATH=$PATH:/var/lib/snapd/snap/bin' | sudo tee -a ~/.bash_profile
    ```
- Install MicroK8s
    ```bash
    sudo snap install microk8s --classic
    sudo usermod -aG microk8s $USER
    sudo chown -f -R $USER ~/.kube
    echo "alias kubectl='microk8s kubectl'" | tee -a ~/.bash_profile
    ```
- 重啟 OS
    - `sudo reboot`
- Manage MicroK8s
    - `microk8s start`