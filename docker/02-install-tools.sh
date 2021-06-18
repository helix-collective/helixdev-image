#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

# Install yarn, node, etc
curl -sL https://deb.nodesource.com/setup_14.x | bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get -y install nodejs yarn

# Install bazelisk
wget -q https://github.com/bazelbuild/bazelisk/releases/download/v1.9.0/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
mv bazelisk-linux-amd64 /usr/local/bin/bazelisk
ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

# Download a version to cache in the docker image:
bazel version

# Install sdkman - See https://sdkman.io/install
# Installing without Modifying Shell Config
# Users will need to source ~/.sdkman/bin/sdkman-init.sh to get it
curl -s "https://get.sdkman.io?rcupdate=false" | bash

# Download a java version to cache in the docker image:
set +x
source ~/.sdkman/bin/sdkman-init.sh
sdk install java 11.0.11.hs-adpt
set -x
