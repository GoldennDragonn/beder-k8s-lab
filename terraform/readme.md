install k8s cluster on aws using Terraform and RKE:

1) edit all *.tf files under `aws-rke-cluster`
2) for Terraform installation steps follow [guide](readme_terraform.md)
3) once cluster is up, connect to each of the instances and proceed as follows:
	* add `ubuntu` user to sudo using `sudo visudo` command
	* create password for `ubuntu` user as sudo
	* install docker with `curl https://releases.rancher.com/install-docker/20.10.sh | sh`
	* install `uidmap` using `sudo apt-get install -y uidmap`
	* to be able to run docker without root user run following commands:
		* `sudo usermod -aG docker $USER`
		* `newgrp docker`
	* Make sure the following environment variables are set (or add them to ~/.bashrc):
		`export PATH=/usr/bin:$PATH`
		`export DOCKER_HOST=unix:///run/user/1000/docker.sock`
	* Apply the changes - `source ~/.bashrc`
	* Check that you can run docker commands without sudo - `docker ps`
	* disable swap - `swapoff -a; sudo sed -i '/swap/d' /etc/fstab`
	* Update sysctl settings for Kubernetes networking:
		cat >>/etc/sysctl.d/kubernetes.conf<<EOF
		net.bridge.bridge-nf-call-ip6tables = 1
		net.bridge.bridge-nf-call-iptables = 1
		EOF
4) Set hostname on each machine:
	* `hostnamectl set-hostname <hostname>`
	* logout and login to see the change
5) Install following tools on deployer machine:
	* install helm
		curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
		sudo apt-get install apt-transport-https --yes
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
		sudo apt-get update
		sudo apt-get install helm
	* install kubectl
		curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
		kubectl version --client --output=yaml
6) Add following ports to security group:
7) Install k8s using RKE:
	* go to `config`
	* edit `cluster.yaml`
	* run `rke up`
8) create secrets and namespaces:
	* go to `helm-charts`
	* run `kubectl create -f preconf/ --recursive`
7) You need NFS, if you're gonna use Amazon EFS, install and mount it according to https://docs.amazonaws.cn/en_us/efs/latest/ug/efs-onpremises.html. 
	* Make sure you have two following Actions in FS policy:
		```   "elasticfilesystem:ClientWrite",
            "elasticfilesystem:ClientMount"
        ```
    * below is a policy example:
    	```{
		    "Version": "2012-10-17",
		    "Statement": [
		        {
		            "Effect": "Allow",
		            "Principal": {
		                "AWS": "*"
		            },
		            "Action": [
		                "elasticfilesystem:ClientWrite",
		                "elasticfilesystem:ClientMount"
		            ],
		            "Condition": {
		                "Bool": {
		                    "elasticfilesystem:AccessedViaMountTarget": "true"
		                }
		            }
		        }
		    ]
		}
		```
8) Set Up NFS Server and Client on Ubuntu 20.04 - a [guide](https://citizix.com/how-to-set-up-nfs-server-and-client-on-ubuntu-20-04/)
9) Kubernetes NFS Subdir External Provisioner - install it using following [guide](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)