#!/bin/bash

# Savings Tracker Full App Bundler and Installer
# This script builds the application and packages it as a native macOS .app bundle.

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

APP_NAME="SavingsTracker"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo -e "${BLUE}=== ${APP_NAME} Pro Packager ===${NC}"

# Check for Swift
if ! command -v swift &> /dev/null
then
    echo -e "${RED}Error: Swift is not installed. Please install Xcode or Xcode Command Line Tools.${NC}"
    exit 1
fi

echo -e "${BLUE}Building optimized release binary...${NC}"
swift build -c release

BINARY_PATH=$(swift build -c release --show-bin-path)/${APP_NAME}

echo -e "${BLUE}Creating App Bundle structure...${NC}"
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

echo -e "${BLUE}Packaging...${NC}"
cp "${BINARY_PATH}" "${MACOS_DIR}/"
if [ -f "Info.plist" ]; then
    cp "Info.plist" "${CONTENTS_DIR}/"
else
    echo -e "${YELLOW}Warning: Info.plist not found, creating a basic one...${NC}"
    cat <<EOF > "${CONTENTS_DIR}/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.jules.${APP_NAME}</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
</dict>
</plist>
EOF
fi

# Set executable permissions
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo -e "${GREEN}Successfully bundled ${APP_BUNDLE}!${NC}"

echo -e "${YELLOW}Moving ${APP_BUNDLE} to your /Applications folder...${NC}"
# Use sudo for Applications folder permissions
if sudo cp -R "${APP_BUNDLE}" /Applications/; then
    echo -e "${GREEN}Successfully installed to /Applications!${NC}"
else
    echo -e "${RED}Failed to move to /Applications. You can manually move it later.${NC}"
fi

echo ""
echo -e "${GREEN}Done! You can now launch ${APP_NAME} from your Applications or by double-clicking the bundle.${NC}"
