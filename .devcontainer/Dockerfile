# FROM Arguments
ARG VARIANT="ubuntu-22.04"

# [Choice] Ubuntu version: bionic, focal
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# Build Arguments
ARG TF_VERSION="1.5.2"
ARG TF_DOCS_VERSION="v0.16.0"
ARG IAMLIVE_VERSION="v0.48.0"
ARG NODE_VERSION="20.x"
ARG SOPS_VERSION="3.7.3"

# ROOT user commands
# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    bash-completion \
    curl \
    gcc \
    git \
    golang \
    libc-dev \
    make \
    pkg-config \
    python3-pip \
    python3-venv \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Set up Terraform
RUN curl -sSLo ./terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_$(dpkg --print-architecture).zip \
    && unzip terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/local/bin/

# Set up Terraform-docs
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/${TF_DOCS_VERSION}/terraform-docs-${TF_DOCS_VERSION}-$(uname)-$(dpkg --print-architecture).tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/ \
    && rm -rf terraform-docs.tar.gz

RUN curl -sSLo ./iamlive.tar.gz https://github.com/iann0036/iamlive/releases/download/${IAMLIVE_VERSION}/iamlive-${IAMLIVE_VERSION}-linux-$(dpkg --print-architecture).tar.gz \
    && tar -xzf iamlive.tar.gz \
    && mv iamlive /usr/local/bin/ \
    && rm -fr iamlive.tar.gz

# Set up tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install SOPS
RUN curl -Lo ./sops.deb https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb \
    && apt --fix-broken install ./sops.deb \
    && rm -rf sops.deb

# Install npm and nodejs
# Install from nodesource using apt-get
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && apt-get install -y nodejs
RUN npm install -g npm

# Symlink /usr/bin/python to /usr/bin/python3
RUN sudo ln -s /usr/bin/python3 /usr/bin/python

# VSCODE user commands
USER vscode

# Setup Bash Completion
ADD --chown=vscode:vscode files/.bash_completion /home/vscode/.bash_completion
RUN mkdir /home/vscode/.bash_completion.d/

ADD --chown=vscode:vscode files/.bash_aliases_aws /home/vscode/.bash_aliases_aws
RUN bash -c "\
    echo 'source $HOME/.bash_aliases_aws' >> ~/.bashrc \
"

# Setup AWS CLI
RUN pip3 install --user \
    awscli \
    terraform-local \
    && echo "complete -C '/home/vscode/.local/bin/aws_completer' aws" >> ~/.bashrc

# Setup Poetry
RUN bash -c "curl -sSL https://install.python-poetry.org | python3 - \
    && echo 'export PATH=$HOME/.local/bin:\$PATH' >> ~/.bashrc" \
    && bash -c "export PATH=$HOME/.local/bin:\$PATH \
    && poetry completions bash > ~/.bash_completion.d/poetry.bash-completion"

# Install some Go packages to support the
# vscode Go extension...
RUN go install -v github.com/ramya-rao-a/go-outline@latest \
    && go install -v golang.org/x/tools/gopls@latest
