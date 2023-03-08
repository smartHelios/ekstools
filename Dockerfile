FROM amazonlinux:2022

ARG IAM_AUTH_VERSION="0.6.2"

RUN yum install -y shadow-utils sudo

RUN useradd -ms /bin/sh eks
RUN usermod -aG wheel eks
RUN echo "%wheel          ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# install AWS CLI, Terraform and Vault
RUN yum install -y yum-utils tar && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    yum -y install terraform && chown eks /usr/bin/terraform && chgrp eks /usr/bin/terraform

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && ./get_helm.sh && chown eks /usr/local/bin/helm && chgrp eks /usr/local/bin/helm

# install aws-iam-authenticator
RUN curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTH_VERSION}/aws-iam-authenticator_${IAM_AUTH_VERSION}_linux_amd64 && \
    chmod +x aws-iam-authenticator && mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && chown eks /usr/local/bin/aws-iam-authenticator && chgrp eks /usr/local/bin/aws-iam-authenticator

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o eks -g wheel -m 0755 kubectl /usr/local/bin/kubectl && chown eks /usr/local/bin/kubectl && chgrp eks /usr/local/bin/kubectl

USER eks
WORKDIR /home/eks