#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

# Install deno via DVM:
# https://deno.land/x/dvm
curl -fsSL https://deno.land/x/dvm/install.sh | sh

# Install a version of deno:
# dvm works by copying actual deno binaries into place
dvm install 1.10.3

# Install dnit:
echo "Using deno version $(deno --version)"
deno install --allow-read --allow-write --allow-run --unstable -f --name dnit https://deno.land/x/dnit@dnit-v1.12.3/main.ts
