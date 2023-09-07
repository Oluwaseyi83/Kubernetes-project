# k8s-jjtech

## Deploy EKS CLuster with Fargate using Terraform

### Prerequisites:
* Terraform installed
* AWS Account and AWS cli installed
* Kubectl installed. Follow this url for installation guide **https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html**

### Note

* This cluster based on the current configuration will be created in the us-east-1 regiona and is setup to wotk only with fargate
* Rerun terraform apply again if you receive **Error: creating EC2 VPC: RequestError: send request failed
│ caused by: Post "https://ec2.us-east-1.amazonaws.com/": read tcp 192.168.1.71:53727->209.54.181.193:443: wsarecv: An existing connection was forcibly closed by the remote host.** and it should deploy the resources
* The deployment takes over 15 minutes

### Resources Created
* VPC and all networking components
* EKS cluster
* aws load balancer controller for ingress
* Fargate profiles for application, aws-load-balancer-controller  and Kube-system namespaces

### Deployment Steps

1. terraform init
2. terraform fmt
3. terraform validate
4. terraform plan
5. terraform apply --auto-appprove

### steps after succesful deployment of cluster with terraform 

* After you provision the EKS with terraform, you would need to update your Kubernetes context to access the cluster with the following command - **aws eks update-kubeconfig --name name-of-cluster --region region-where-cluster-is-deployed**


* To patch coredns to run on fargate nodes, run the command below 

****
kubectl patch deployment coredns \
-n kube-system \
--type json \
-p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'



## Install minikube in ubuntu linux

### What you’ll need
- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager, such as: Docker, QEMU, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMware Fusion/Workstation

1. Navigate to this url for installaition instructions
## https://minikube.sigs.k8s.io/docs/start/

2. Select your OS (in this case linux)

3. Install docker for ubuntu. Use link for installtion guide (https://docs.docker.com/engine/install/ubuntu/)

- sudo apt-get update
- sudo apt-get install ca-certificates curl gnupg
- sudo install -m 0755 -d /etc/apt/keyrings
- curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
- sudo chmod a+r /etc/apt/keyrings/docker.gpg
- echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
- sudo apt-get update
- sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
- docker --version
- sudo usermod -aG docker $USER && newgrp docker

3. Install Virtualbox using the link for installation guide : https://www.virtualbox.org/wiki/Linux_Downloads

# Add the following line to your /etc/apt/sources.list 
- sudo vim /etc/apt/sources.list 

# Then paste the following below and save. press "i" to be on insert mode and ":wq!" to save the file
- deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian jammy contrib

# Download and verify the oracle public key by running the command below
- wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

# Install virtual box by running 
- sudo apt-get update
- sudo apt-get install virtualbox-6.1

4. STart Minikube by running 
- minikube start


## Install Minikube on Windows

### What you’ll need
- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager, such as: Docker, QEMU, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMware Fusion/Workstation

To install the latest minikube stable release on x86-64 Windows using Chocolatey:

1. If the Chocolatey Package Manager is installed, use the following command:
- choco install minikube

2. From a terminal with administrator access (but not logged in as root), run:

- minikube start

3. STart intercating with your cluster by running 
- kubectl get po