FROM docker.io/ubuntu:24.04
RUN --mount=type=bind,source=apt.conf,target=/etc/apt/apt.conf \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get upgrade \
    && apt-get autoremove sudo \
    && apt-get install \
    bash-completion \
    ca-certificates \
    curl \
    git \
    gnupg \
    openssl \
    tar \
    unzip \
    wget

RUN curl --tlsv1.3 -sSL --output "/usr/local/bin/kubectl" \
    "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN --mount=type=tmpfs,target=/tmp/terraform \
    curl --tlsv1.3 -sSL --output "/tmp/terraform/terraform.zip" \
    "https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip" \
    && unzip /tmp/terraform/terraform.zip terraform -d "/usr/local/bin"

RUN cd "/usr/local/bin" \
    && chown root:root $(ls -A) \
    && chmod 0755 $(ls -A)
