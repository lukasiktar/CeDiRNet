# ============================================================
# CeDiRNet Docker Image
# https://github.com/vicoslab/CeDiRNet
#
# Base: CUDA 11.1 + cuDNN 8 on Ubuntu 20.04
# Python: 3.8 (3.6 is EOL; 3.8 is stable and compatible)
# PyTorch: 1.9.1+cu111 (as recommended by the repo)
# ============================================================
FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04


# ── System packages ─────────────────────────────────────────
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3.8 \
        python3.8-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        git \
        wget \
        curl \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libgl1-mesa-glx \
        build-essential \
        cmake \
    && rm -rf /var/lib/apt/lists/*


# Make python3.8 the default python / pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 \
 && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 \
 && python -m pip install --upgrade pip setuptools wheel
 
# ── PyTorch with CUDA 11.1 (repo-recommended versions) ──────
RUN pip install \
        torch==1.9.1+cu111 \
        torchvision==0.10.1+cu111 \
        torchaudio==0.9.1 \
        -f https://download.pytorch.org/whl/torch_stable.html

# ── CeDiRNet Python dependencies ────────────────────────────
RUN pip install \
        numpy \
        scipy \
        scikit-image \
        scikit-learn \
        matplotlib \
        Pillow \
        tqdm \
        tensorboard \
        opencv-python-headless

# ── Copy only requirements.txt to install deps at build time ─
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR /workspace/CeDiRNet


ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

CMD ["/bin/bash"]
