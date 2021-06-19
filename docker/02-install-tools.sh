#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

# Install deno via DVM:
# https://deno.land/x/dvm
curl -fsSL https://deno.land/x/dvm/install.sh | sh

dvm install 1.10.3

# Install dnit:
deno install --allow-read --allow-write --allow-run --unstable -f --name dnit https://deno.land/x/dnit@dnit-v1.12.3/main.ts

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
# The Dockerfile has set SDKMAN_DIR so that it is not in a "HOME" dir (neither root or /github/home etc)
# So that it works during this docker image build and github action CI usage
echo "Using SDKMAN_DIR=${SDKMAN_DIR}"
curl -s "https://get.sdkman.io" | bash

# Download a java version to cache in the docker image:
set +x
source ${SDKMAN_DIR}/bin/sdkman-init.sh
sdk install java 11.0.11.hs-adpt
set -x
