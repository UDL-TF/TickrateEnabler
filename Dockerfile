# Use Ubuntu 22.04 as the base image for modern toolchain
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and Python dependencies
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  clang \
  g++-multilib \
  gcc-multilib \
  python3 \
  python3-pip \
  git \
  zip \
  lib32stdc++6 \
  lib32gcc-s1 \
  && python3 -m pip install --upgrade pip setuptools wheel \
  && pip install git+https://github.com/alliedmodders/ambuild

# Set the working directory
WORKDIR /app

# Clone necessary repositories with specific versions
RUN git clone --branch master --recurse-submodules https://github.com/alliedmodders/metamod-source.git metamod-source && \
  git clone https://github.com/alliedmodders/hl2sdk-manifests.git hl2sdk-manifests && \
  git clone --branch tf2 https://github.com/alliedmodders/hl2sdk.git hl2sdk-tf2

# Copy your own repository into the Docker image
COPY . /app/TickrateEnabler

# Set the working directory to your repository
WORKDIR /app/TickrateEnabler

# Create build directory
RUN mkdir -p build

WORKDIR /app/TickrateEnabler/build

# Configure and build the project with new AMBuild 2.2 system
RUN python3 ../configure.py \
  --enable-optimize \
  --hl2sdk-manifest-path=/app/hl2sdk-manifests \
  --mms-path=/app/metamod-source \
  --hl2sdk-root=/app \
  --targets=x86 \
  && ambuild

# Package the build artifacts
RUN cd package && \
  zip -r /app/TickrateEnabler-linux.zip addons/

# Final instructions (optional)
CMD ["bash"]
