#!/bin/bash

# AOSP Android TV 12 Build Setup Script
# This script helps set up the build environment for Android TV 12 with Amlogic OHM device tree

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}AOSP Android TV 12 Build Setup Script${NC}"
echo "========================================="

# Check if running on supported OS
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${RED}Error: This script is designed for Linux systems only.${NC}"
    exit 1
fi

# Check available disk space (need at least 400GB)
AVAILABLE_SPACE=$(df . | tail -1 | awk '{print $4}')
REQUIRED_SPACE=$((400 * 1024 * 1024)) # 400GB in KB

if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    echo -e "${RED}Error: Insufficient disk space. Need at least 400GB free.${NC}"
    echo "Available: $(($AVAILABLE_SPACE / 1024 / 1024))GB"
    exit 1
fi

# Check RAM (recommend at least 16GB)
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
if [ "$TOTAL_RAM" -lt 16 ]; then
    echo -e "${YELLOW}Warning: Less than 16GB RAM detected. Build may be slow or fail.${NC}"
    echo "Consider adding swap space or using a machine with more RAM."
fi

echo -e "${GREEN}✓ System requirements check passed${NC}"

# Install required packages
echo -e "${YELLOW}Installing required packages...${NC}"
sudo apt-get update
sudo apt-get install -y \
    git-core gnupg flex bison build-essential zip curl zlib1g-dev \
    gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev \
    x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils \
    xsltproc unzip fontconfig python3 python3-pip

echo -e "${GREEN}✓ Required packages installed${NC}"

# Install repo tool
echo -e "${YELLOW}Installing repo tool...${NC}"
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# Add ~/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
    export PATH=~/bin:$PATH
fi

echo -e "${GREEN}✓ Repo tool installed${NC}"

# Setup build directory
BUILD_DIR="$HOME/aosp-android12-tv"
echo -e "${YELLOW}Setting up build directory: $BUILD_DIR${NC}"

if [ -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}Build directory already exists. Using existing directory.${NC}"
else
    mkdir -p "$BUILD_DIR"
fi

cd "$BUILD_DIR"

# Initialize repo if not already done
if [ ! -d ".repo" ]; then
    echo -e "${YELLOW}Initializing AOSP repository...${NC}"
    repo init -u https://android.googlesource.com/platform/manifest -b android-12.1.0_r27
    echo -e "${GREEN}✓ Repository initialized${NC}"
else
    echo -e "${YELLOW}Repository already initialized${NC}"
fi

# Setup local manifests
mkdir -p .repo/local_manifests

# Copy device manifest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/aosp_manifest.xml" .repo/local_manifests/device.xml

echo -e "${GREEN}✓ Device manifest copied${NC}"

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. cd $BUILD_DIR"
echo "2. repo sync -c -j\$(nproc)  # This will take several hours"
echo "3. source build/envsetup.sh"
echo "4. lunch aosp_atv_generic-userdebug"
echo "5. m -j\$(nproc)  # Start the build"
echo ""
echo "Note: You'll need to obtain proprietary vendor blobs for the Amlogic OHM device."
echo "See AOSP_BUILD.md for detailed instructions."