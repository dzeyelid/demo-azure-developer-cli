FROM mcr.microsoft.com/devcontainers/base:jammy

# Install Azure Functions Core Tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
  && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list' \
  && apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
    azure-functions-core-tools-4 \
    xdg-utils \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
