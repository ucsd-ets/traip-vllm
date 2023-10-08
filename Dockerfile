
FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get -qq install -y --no-install-recommends \
    git \
    curl \
    rsync \
    unzip \
    less \
    vim \
    gnupg \
    htop \
    openssh-client \
    p7zip \
    apt-utils \
    jq \
    p7zip-full \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates

# Install Miniforge3 (mamba-based open miniconda)
ARG MFURL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

RUN curl -L -o /tmp/Miniforge3.sh "${MFURL}" && \
    bash /tmp/Miniforge3.sh -b -p /opt/conda && \
    rm -f /tmp/Miniforge3.sh

COPY vllm-environment.yml /root/vllm-environment.yml

RUN . /opt/conda/bin/activate && \
    mamba env create -p /opt/vllm -f /root/vllm-environment.yml

CMD echo 'Hint: /opt/conda/bin/conda run -p /opt/vllm python -m vllm.entrypoints.openai.api_server --host 0.0.0.0 --port 8000 --model gpt2'
