#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

# Install bazelisk
wget -q https://github.com/bazelbuild/bazelisk/releases/download/v1.9.0/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
mv bazelisk-linux-amd64 /usr/local/bin/bazelisk
ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

# Download a recent version (for default use and to cache in the docker image)
bazel version

# Install sdkman - See https://sdkman.io/install
# The Dockerfile has set SDKMAN_DIR so that it is not in a "HOME" dir (neither root or /github/home etc)
# So that it works during this docker image build and github action CI usage
echo "Using SDKMAN_DIR=${SDKMAN_DIR}"
curl -s "https://get.sdkman.io" | bash

cat << EOF > ${SDKMAN_DIR}/etc/config
# https://sdkman.io/usage#config

# make sdkman non-interactive, preferred for CI environments
sdkman_auto_answer=true

# perform automatic selfupdates?
sdkman_auto_selfupdate=false

# enable colour mode?
sdkman_colour_enable=false
EOF

# Download a java version (for default use and to cache in the docker image)
set +x
set +u
source ${SDKMAN_DIR}/bin/sdkman-init.sh
sdk install java 11.0.11.hs-adpt
set -u
set -x

# Note: Projects need to run the following in order to source the SDKMAN environment:
# source ${SDKMAN_DIR}/bin/sdkman-init.sh
