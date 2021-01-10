#/bin/bash

# 1. Check network adapters
echo "==== Check network adapters"
cat << EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# 2. Installing kubeadm, kubelet and kubectl
echo "==== Installing kubeadm, kubelet and kubectl"
cat << EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# 3. Set SELinux in permissive mode (effectively disabling it)
# echo "==== Set SELinux in permissive mode (effectively disabling it)"
# sudo setenforce 0
# sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

# 4. Restarting the kubelet
echo "==== Restarting the kubelet"
systemctl daemon-reload
systemctl restart kubelet
systemctl enable kubelet