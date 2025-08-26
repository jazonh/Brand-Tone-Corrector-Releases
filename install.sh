#!/bin/bash

# One-command installer for Brand Tone Corrector
# Usage: curl -s https://raw.githubusercontent.com/jazonh/Brand-Tone-Corrector-Releases-Releases/main/install.sh | bash

set -e

REPO="jazonh/Brand-Tone-Corrector-Releases-Releases"
APP_NAME="Brand Tone Corrector"
INSTALL_DIR="/Applications"

echo "🚀 Installing Brand Tone Corrector..."
echo ""

# Get latest release info
echo "📡 Checking for latest version..."
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep -o '"browser_download_url": "[^"]*\.zip"' | cut -d '"' -f 4)
VERSION=$(echo "$LATEST_RELEASE" | grep -o '"tag_name": "[^"]*"' | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ Could not find download URL. Please check manually at:"
    echo "   https://github.com/$REPO/releases/latest"
    exit 1
fi

echo "✅ Found version: $VERSION"
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the app
echo "📥 Downloading $APP_NAME..."
curl -L -o "app.zip" "$DOWNLOAD_URL"

if [ ! -f "app.zip" ]; then
    echo "❌ Download failed"
    exit 1
fi

echo "✅ Download complete"
echo ""

# Unzip
echo "📦 Extracting application..."
unzip -q "app.zip"

# Find the .app bundle
APP_BUNDLE=$(find . -name "*.app" -type d | head -1)

if [ -z "$APP_BUNDLE" ]; then
    echo "❌ Could not find application bundle in download"
    exit 1
fi

# Remove existing installation if it exists
if [ -d "$INSTALL_DIR/$APP_NAME.app" ]; then
    echo "🗑️  Removing existing installation..."
    rm -rf "$INSTALL_DIR/$APP_NAME.app"
fi

# Install to Applications
echo "📱 Installing to Applications folder..."
sudo cp -R "$APP_BUNDLE" "$INSTALL_DIR/"

# Remove quarantine attribute to bypass Gatekeeper
echo "🔓 Configuring permissions..."
sudo xattr -r -d com.apple.quarantine "$INSTALL_DIR/$APP_NAME.app" 2>/dev/null || true

# Clean up
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "✅ $APP_NAME has been installed to Applications"
echo "✅ Gatekeeper permissions configured"
echo "✅ App is ready to use"
echo ""
echo "🚀 Launch the app:"
echo "   • Open Applications folder"
echo "   • Double-click '$APP_NAME'"
echo "   • Or press Cmd+Space and type 'Brand Tone'"
echo ""
echo "📖 Need help? Check the documentation:"
echo "   https://github.com/$REPO/blob/main/README.md"
