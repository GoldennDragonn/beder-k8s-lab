#!/bin/bash -xe

apt update
apt install -y curl
# Rancher's Docker installation scripts
echo "[TASK 1] Rancher's Docker installation scripts"
curl https://releases.rancher.com/install-docker/20.10.sh | sh

#Add your user to the docker group.(the user master)
echo "[TASK 2] Add your user to the docker group."
sudo usermod -aG docker ubuntu

#run the following command to activate the changes to groups
echo "[TASK 3] Activate the changes to groups."
newgrp docker

#Disable swap
echo "[TASK 4] Disable swap."
swapoff -a; sed -i '/swap/d' /etc/fstab

#Update sysctl settings for Kubernetes networking
echo "[TASK 5] Update sysctl settings for Kubernetes networking"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# install helm
echo "[TASK 6] Install helm"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

#install kubectl
echo "[TASK 8] Install kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --output=yaml

#install RKE
echo "[TASK 9] Install RKE binary"
mkdir -p ~/rke
cd ~/rke
wget https://github.com/rancher/rke/releases/download/v1.4.3/rke_linux-amd64
sudo mv rke_linux-amd64 /usr/local/bin/rke
chmod +x /usr/local/bin/rke
#Confirm that RKE is now executable by running the following command:
rke --version

# copy cluster.yaml 
#echo "[TASK 9] copying cluster.yaml"
#mkdir -p /home/ubuntu/rke/
#cp "/media/denislaz/Data/Projects/RKE_k8s/k8s-rke-installation/config/cluster.yml" /home/ubuntu/