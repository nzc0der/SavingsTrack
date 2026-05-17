#!/bin/bash

# Savings Tracker Installer for macOS
# This script builds the application using the Swift toolchain.

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Savings Tracker Installer ===${NC}"

# Check for Swift
if ! command -v swift &> /dev/null
then
    echo -e "${RED}Error: Swift is not installed. Please install Xcode or Xcode Command Line Tools.${NC}"
    exit 1
fi

echo -e "${BLUE}Building Savings Tracker...${NC}"

# Build the project
swift build -c release

# Find the binary
BINARY_PATH=$(swift build -c release --show-bin-path)/SavingsTracker

if [ -f "$BINARY_PATH" ]; then
    echo -e "${GREEN}Build successful!${NC}"
    echo ""
    echo -e "You can run the app using:"
    echo -e "${BLUE}$BINARY_PATH${NC}"
    echo ""
    echo -e "Or create a symbolic link to run it from anywhere:"
    echo -e "sudo ln -s \"$BINARY_PATH\" /usr/local/bin/savingstracker"
else
    echo -e "${RED}Build failed: Binary not found.${NC}"
    exit 1
fi
