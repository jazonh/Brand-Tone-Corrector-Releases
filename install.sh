#!/bin/bash

# Smart Install Script for Brand Tone Corrector
# Based on the proven Design Review Helper installation system
# Handles quarantine removal and provides seamless installation experience

set -e

echo "🚀 Brand Tone Corrector - Smart Installer"
echo "=========================================="
echo ""

# Configuration
REPO="jazonh/Brand-Tone-Corrector-Releases"
APP_NAME="Brand Tone Corrector"
TEMP_DIR="/tmp/brand-tone-corrector-install"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ This installer is for macOS only."
    exit 1
fi

# Check for required tools
if ! command -v curl &> /dev/null; then
    echo "❌ curl is required but not installed."
    exit 1
fi

if ! command -v unzip &> /dev/null; then
    echo "❌ unzip is required but not installed."
    exit 1
fi

echo "📋 Installing Brand Tone Corrector..."
echo ""

# Create temporary directory
echo "📁 Creating temporary directory..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Get latest release information
echo "🔍 Finding latest version..."
LATEST_URL="https://api.github.com/repos/$REPO/releases/latest"
DOWNLOAD_URL=$(curl -s "$LATEST_URL" | grep -o 'https://github.com/[^"]*\.zip' | head -1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ Could not find latest release. Please check your internet connection."
    exit 1
fi

VERSION=$(echo "$DOWNLOAD_URL" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
echo "✅ Found latest version: $VERSION"

# Download latest version
echo "📥 Downloading $VERSION..."
ZIP_FILE="brand-tone-corrector-latest.zip"
curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL"

if [ ! -f "$ZIP_FILE" ]; then
    echo "❌ Download failed."
    exit 1
fi

echo "✅ Download complete"

# Extract the app
echo "📦 Extracting application..."
unzip -q "$ZIP_FILE"

if [ ! -d "$APP_NAME.app" ]; then
    echo "❌ Application not found in downloaded package."
    exit 1
fi

# Remove quarantine attributes (critical for seamless updates)
echo "🔓 Removing quarantine attributes..."
xattr -dr com.apple.quarantine "$APP_NAME.app" 2>/dev/null || true

# Remove existing installation if present
if [ -d "/Applications/$APP_NAME.app" ]; then
    echo "🗑️  Removing previous installation..."
    rm -rf "/Applications/$APP_NAME.app"
fi

# Install to Applications
echo "📋 Installing to Applications folder..."
mv "$APP_NAME.app" "/Applications/"

if [ ! -d "/Applications/$APP_NAME.app" ]; then
    echo "❌ Installation failed."
    exit 1
fi

# Cleanup
echo "🧹 Cleaning up temporary files..."
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 Installation Complete!"
echo "========================"
echo ""
echo "✅ Brand Tone Corrector $VERSION has been installed successfully!"
echo ""
echo "📱 **Next Steps:**"
echo "   1. Open Brand Tone Corrector from Applications folder"
echo "   2. Configure your OpenAI API key in Settings"
echo "   3. Start correcting tone with AI-powered suggestions!"
echo ""
echo "🔄 **Automatic Updates:**"
echo "   The app will automatically check for updates and notify you when new versions are available."
echo "   Future updates will install seamlessly without additional setup."
echo ""
echo "🚀 **Opening Brand Tone Corrector now...**"

# Open the application
open "/Applications/$APP_NAME.app"

echo ""
echo "Thank you for using Brand Tone Corrector! 🎊"
echo ""
echo "💡 **Tips:**"
echo "   • The app includes built-in brand guidelines for TCGplayer"
echo "   • Try the sample texts to see how tone correction works"
echo "   • Check Settings → Updates for manual update checks"
echo ""
echo "🔗 **Resources:**"
echo "   • GitHub: https://github.com/jazonh/Brand-Tone-Corrector"
echo "   • Releases: https://github.com/$REPO"
echo ""
echo "✨ Installation complete - enjoy your enhanced brand communication!"