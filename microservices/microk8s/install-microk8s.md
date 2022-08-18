# Install Microk8s
- Update Server and Install Snap
    ```bash
    sudo yum install epel-release -y
    sudo yum update -y
    sudo yum install snapd -y
    sudo systemctl enable snapd.socket --now
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
- Adding a node
    - `microk8s add-node`

# Tools
- [nip.io](https://nip.io/)
    - 10.0.0.1.nip.io maps to 10.0.0.1
    - 192-168-1-250.nip.io maps to 192.168.1.250
- [How to access Microk8s dashboard without proxy](https://garywoodfine.com/how-to-access-microk8s-dashboard-without-proxy/)