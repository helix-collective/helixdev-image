#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

# Update first prior to installing packages from the standard repos
apt-get update

# Add curl and apt-transport-https for installing from https repositories
apt-get install -y curl apt-transport-https gnupg2

# Install yarn, node, etc
curl -sL https://deb.nodesource.com/setup_10.x | bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get -y install nodejs yarn

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
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Unpack java 8, with specified minor version
MINOR=152
mkdir -p /opt/jdk
cd /opt/jdk
tar -zxf /tmp/jdk-8u$MINOR-linux-x64.tar.gz -C /opt/jdk
update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_$MINOR/bin/java 100
update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_$MINOR/bin/javac 100
update-alternatives --install /usr/bin/jstack jstack /opt/jdk/jdk1.8.0_$MINOR/bin/jstack 100
update-alternatives --install /usr/bin/javadoc javadoc /opt/jdk/jdk1.8.0_$MINOR/bin/javadoc 100
update-alternatives --install /usr/bin/jar jar /opt/jdk/jdk1.8.0_$MINOR/bin/jar 100

# Install bazel from a binary release
VERSION=2.1.1
INSTALLER=bazel-$VERSION-installer-linux-x86_64.sh
wget -q https://github.com/bazelbuild/bazel/releases/download/$VERSION/$INSTALLER
chmod +x $INSTALLER
./$INSTALLER
rm $INSTALLER
/usr/local/bin/bazel version
rm -rf /root/.cache/bazel/

# symlink nginx so that NginxRunnerTest can work correctly
ln -s /usr/sbin/nginx /usr/local/bin/nginx 
# Update permissions of default log and lib directories so that buildkite agent can run nginx without issues
chown root:www-data /var/lib/nginx /var/log/nginx
chmod 775 /var/lib/nginx /var/log/nginx

