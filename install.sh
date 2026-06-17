#!/bin/bash
#
# ssh-image-paste installer
#
# One-liner install:
#   curl -fsSL https://raw.githubusercontent.com/aikero-labs/ssh-image-paste/main/install.sh | bash
#
set -e

REPO="aikero-labs/ssh-image-paste"
BIN_DIR="${HOME}/.local/bin"
SCRIPT_NAME="ssh-image-paste"

echo "Installing $SCRIPT_NAME..."

# Ensure ~/.local/bin exists
mkdir -p "$BIN_DIR"

# Install dependency: pngpaste
if ! command -v pngpaste &>/dev/null; then
    echo "Installing pngpaste (required dependency)..."
    if command -v brew &>/dev/null; then
        brew install pngpaste
    else
        echo "Error: Homebrew is required to install pngpaste."
        echo "Install Homebrew first: https://brew.sh"
        exit 1
    fi
else
    echo "pngpaste: already installed"
fi

# Download the script
DOWNLOAD_URL="https://raw.githubusercontent.com/${REPO}/main/${SCRIPT_NAME}"
echo "Downloading from ${DOWNLOAD_URL}..."
curl -fsSL "$DOWNLOAD_URL" -o "${BIN_DIR}/${SCRIPT_NAME}"
chmod +x "${BIN_DIR}/${SCRIPT_NAME}"

# Check PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo "Note: $BIN_DIR is not in your PATH. Add it:"
    SHELL_RC="~/.zshrc"
    [[ "$SHELL" == */bash ]] && SHELL_RC="~/.bashrc"
    echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> $SHELL_RC"
    echo ""
fi

echo ""
echo "Installed successfully: ${BIN_DIR}/${SCRIPT_NAME}"
echo ""
echo "Usage:"
echo "  ssh-image-paste              # Auto-detect SSH target"
echo "  ssh-image-paste user@host    # Specify target"
echo "Next: Set up a keyboard shortcut"
echo ""
echo "  iTerm2: Settings > Keys > Key Bindings > +"
echo "    Shortcut:  your choice (e.g. Shift+Option+Cmd+I)"
echo "    Action:    Run Coprocess"
echo "    Command:   ${BIN_DIR}/${SCRIPT_NAME} >/dev/null 2>&1"
echo ""
echo "  Other terminals: see https://github.com/${REPO}#set-up-a-keyboard-shortcut"
