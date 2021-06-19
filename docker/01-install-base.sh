#!/bin/bash
set -ex

# Install base packages

export DEBIAN_FRONTEND=noninteractive

# Update first prior to installing packages from the standard repos
apt-get update

# Add curl and apt-transport-https for installing from https repositories
apt-get install -y curl apt-transport-https gnupg2

# Install packages
apt-get install -y \
  build-essential \
  libssl-dev \
  libffi-dev \
  libzip-dev \
  libbz2-dev \
  pkg-config \
  zip \
  g++ \
  zlib1g-dev \
  unzip \
  git \
  wget \
  python \
  python-dev \
  python-pip \
  python3 \
  python3-pip \
  python3-gdbm \
  awscli \
  nginx

# Install some python3 packages via pip
pip3 install doit pystache

# Install docker and docker-compose
cd /tmp
apt-get install -y iptables libdevmapper1.02.1
wget -q https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_1.2.6-3_amd64.deb
wget -q https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_19.03.8~3-0~ubuntu-bionic_amd64.deb
wget -q https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_19.03.8~3-0~ubuntu-bionic_amd64.deb
dpkg -i containerd.io_1.2.6-3_amd64.deb
dpkg -i docker-ce-cli_19.03.8~3-0~ubuntu-bionic_amd64.deb
dpkg -i docker-ce_19.03.8~3-0~ubuntu-bionic_amd64.deb
rm /tmp/*.deb
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# symlink nginx so that NginxRunnerTest can work correctly
ln -s /usr/sbin/nginx /usr/local/bin/nginx 
# Update permissions of default log and lib directories so that buildkite agent can run nginx without issues
chown root:www-data /var/lib/nginx /var/log/nginx
chmod 775 /var/lib/nginx /var/log/nginx
