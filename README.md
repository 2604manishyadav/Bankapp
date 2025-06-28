
# End-to-End Bank Application Deployment on AWS EKS


## This is a multi-tier bank an application written in Java (Springboot).

#### Screenshots

![App Screenshot](https://github.com/2604manishyadav/Bankapp/blob/86627cd7887c50fd3be7550a35dc65625a5bde15/springboot.PNG)

### Tech stack used in this project:

- Github (Code)  
- Terraform (Infrastructure)  
- Docker (Containerization)  
- Jenkins (CI)  
- ArgoCD (CD)  
- AWS EKS (Kubernetes)  
- Helm (Monitoring using grafana and prometheus)


# STEPS TO Deploy

### Create a Master machine on AWS (t2.large) and 29 GB of storage using Terraform

### Installation of Terraform

Install Terraform in your local machine using shell script
 
#### terraform_install.sh 

Verify Installation

    terraform --version

### Install awscli using shell script

#### awscli-install.sh

Prerequisite for configure awscli

IAM User with access keys and secret access keys

#### Configure awscli

    aws configure

### Create ec2 instance using terraform configuration file

    terraform init 
    terraform plan  
    terraform apply

### Install eksctl (used to create and manage EKS clusters)

    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    eksctl version

### EKS cluster creation command without nodegroup

    eksctl create cluster --name=bankapp-cluster --region=eu-west-1 --without-nodegroup --version=1.32

### Associate OIDC to EKS cluster

    eksctl utils associate-iam-oidc-provider --cluster bankapp-cluster --approve

### Update the vpc-cni addon in your EKS

    eksctl update addon --name vpc-cni --cluster bankapp-cluster --force

### Create nodegroup for your cluster

    eksctl create nodegroup --cluster=bankapp-cluster \
    --region=eu-west-1 \
    --name=bankapp-ng \
    --node-type=t2.medium \
    --nodes=2 \
    --nodes-min=2 \
    --nodes-max=2 \
    --node-volume-size=20 \
    --ssh-access \
    --ssh-public-key=bankapp-automate-key


#### NOTE :   

Make sure public key is available in your aws key pair 



