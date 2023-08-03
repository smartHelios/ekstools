FROM amazonlinux:2022

ARG IAM_AUTH_VERSION="0.6.2"

RUN yum install -y shadow-utils

# install utilities, AWS CLI and Terraform

RUN yum install -y yum-utils awscli openssl git tar make && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    yum -y install terraform vault && chown root /usr/bin/vault

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && ./get_helm.sh

# install aws-iam-authenticator
RUN curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTH_VERSION}/aws-iam-authenticator_${IAM_AUTH_VERSION}_linux_amd64 && \
    chmod +x aws-iam-authenticator && mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install kubectl /usr/local/bin/kubectl