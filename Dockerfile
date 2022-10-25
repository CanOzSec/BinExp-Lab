
# Build the docker container -> build.sh
# Run the docker container -> run.sh
# Get a shell in the container -> shell.sh

FROM ubuntu:22.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Copy things to the docker.
COPY dot_rizinrc /root/.rizinrc
COPY dot_bashrc /root/.bashrc

# Update the repos and install packages.
RUN apt-get update && \
apt-get install -y build-essential jq strace ltrace curl wget rubygems gcc dnsutils netcat gcc-multilib net-tools \
  vim gdb gdb-multiarch python3 python3-pip python3-dev libssl-dev libffi-dev wget git make procps \
  libpci-dev libdb-dev libxt-dev libxaw7-dev tmux file

# Update pip and install tools.
RUN pip install --upgrade pip
RUN pip install --upgrade pwntools
RUN pip install meson capstone r2pipe keystone-engine unicorn ninja
RUN mkdir /opt/tools && \
cd /opt/tools && git clone https://github.com/JonathanSalwan/ROPgadget && \
cd /opt/tools && git clone https://github.com/niklasb/libc-database

# Install gef for gdb.
RUN cd /opt/tools && git clone https://github.com/hugsy/gef && cd /opt/tools/gef && \
wget -O .gdbinit-gef.py -q https://raw.githubusercontent.com/hugsy/gef/main/gef.py && \
echo source /opt/tools/gef/.gdbinit-gef.py > /root/.gdbinit

# Install rizin.
RUN cd /opt/tools && git clone --recurse-submodules https://github.com/rizinorg/rizin && \
cd rizin && meson build && ninja -C build && ninja -C build install
