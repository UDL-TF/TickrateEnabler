# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Install required packages and Python dependencies
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y clang g++-multilib python3 python3-pip git zip && \
  python3 -m pip install --upgrade pip setuptools wheel && \
  pip3 install git+https://github.com/alliedmodders/ambuild

# Set the working directory
WORKDIR /app

# Clone necessary repositories
RUN git clone --branch master --recurse-submodules https://github.com/alliedmodders/metamod-source.git metamod-source && \
  git clone --branch master --recurse-submodules https://github.com/alliedmodders/sourcemod sourcemod && \
  git clone --branch tf2 --recurse-submodules https://github.com/alliedmodders/hl2sdk.git hl2sdk-tf2

# Copy your own repository into the Docker image
COPY . /app/TickrateEnabler

# Set the working directory to your repository
WORKDIR /app/TickrateEnabler

RUN mkdir build

WORKDIR /app/TickrateEnabler/build

# Configure and build the project
RUN python3 ../configure.py --enable-optimize --hl2sdk-root=../../ --mms-path=../../metamod-source --sm-path=../../sourcemod --sdks=tf2 && \
  ambuild

# Package the build artifacts
RUN cd build/Package-tf2 && \
  zip -r /app/TickrateEnabler-linux.zip 

# Final instructions (optional)
CMD ["bash"]
