#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

# install nvm script (using PROFILE=/dev/null to skip installing in "home profile")
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | PROFILE=/dev/null bash

# Download a node version (for default use and to cache in the docker image)
set +x
set +u
source $NVM_DIR/nvm.sh
nvm install --lts
nvm use --lts
set -u
set -x

# Install yarn (yarn 1.x classic - 'global' install within nvm setup above)
# Projects may choose to get onto yarn 2 using a few steps in the project repo: https://yarnpkg.com/getting-started/install
npm install -g yarn

# Note: Projects need to run the following in order to source the NVM environment:
# source $NVM_DIR/nvm.sh
#
