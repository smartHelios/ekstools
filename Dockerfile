FROM amazonlinux:2022

ARG IAM_AUTH_VERSION="0.6.2"

RUN yum install -y shadow-utils sudo

RUN useradd -ms /bin/sh eks
RUN usermod -aG wheel eks
RUN echo "%wheel          ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# install AWS CLI, Terraform and Vault
RUN sudo yum install -y yum-utils awscli openssl git tar && \
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    sudo yum -y install terraform vault && sudo chown eks /usr/bin/vault

USER eks
WORKDIR /home/eks

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && sudo ./get_helm.sh

# install aws-iam-authenticator
RUN sudo curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTH_VERSION}/aws-iam-authenticator_${IAM_AUTH_VERSION}_linux_amd64 && \
    sudo chmod +x aws-iam-authenticator && sudo mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo install -o eks -g wheel -m 0755 kubectl /usr/local/bin/kubectl