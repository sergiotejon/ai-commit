#!/bin/bash

set -e

# Usage:
# curl -s https://raw.githubusercontent.com/sergiotejon/ai-commit/main/scripts/get-ai-commit.sh | sudo bash

REPO="sergiotejon/ai-commit"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="ai-commit"
SYMLINK_NAME="git-ai-commit"

# Detect system information
OS=$(uname -s)
ARCH=$(uname -m)

# Check if the system is supported
if [[ "$OS" == "Linux" ]]; then
    OS_TYPE="linux"
elif [[ "$OS" == "Darwin" ]]; then
    OS_TYPE="darwin"
else
    echo "Operating system $OS not supported."
    exit 1
fi

# Get the latest release tag
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Form the asset URL
ASSET_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"browser_download_url":' | grep "${OS_TYPE}_${ARCH}" | sed -E 's/.*"([^"]+)".*/\1/')

# Download the binary
if [[ -z "$ASSET_URL" ]]; then
    echo "Could not find a binary for $OS $ARCH"
    exit 1
fi

echo $ASSET_URL
echo "Downloading $ASSET_URL"
curl -L -o "$INSTALL_DIR/$BINARY_NAME" "$ASSET_URL"

# Make the binary executable
chmod +x "$INSTALL_DIR/$BINARY_NAME"

# Symlink the binary for git extension
ln -sf "$INSTALL_DIR/$BINARY_NAME" "$INSTALL_DIR/$SYMLINK_NAME"

echo "Installation complete: $INSTALL_DIR/$BINARY_NAME"
echo "Symbolic link created: $INSTALL_DIR/$SYMLINK_NAME"