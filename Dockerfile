FROM  nvcr.io/nvidia/cuda:12.3.1-devel-ubuntu22.04

ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive=value

# Install dependencies
RUN apt-get update 
RUN apt-get install -y \
    wget \
    git \
    # curl \
    # unzip \
    # ffmpeg \
    sudo \
    python3-tk \
    python3 \
    # lightgbm GPU
    cmake \
    build-essential \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev 

RUN wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python3
RUN pip install lightgbm \
    --no-binary lightgbm \
    --no-cache lightgbm \
    --config-settings=cmake.define.USE_CUDA=ON \
    --config-settings=cmake.define.USE_GPU=ON 

COPY ./requirements.txt /tmp/requirements.txt

# # Install libralies
RUN pip3 install --no-cache-dir --upgrade pip setuptools \
    && pip3 install --no-cache-dir -r /tmp/requirements.txt

# Set non root user
ARG USERNAME=vscode
ARG GROUPNAME=vscode
ARG UID=1000
ARG GID=1000
ARG PASSWORD=vscode
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/workspaces