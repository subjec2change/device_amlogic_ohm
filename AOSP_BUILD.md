# AOSP Android TV 12 Build Instructions

This repository contains the device tree for building Android TV 12 from AOSP sources using the Amlogic OHM platform.

## Prerequisites

- Ubuntu 18.04+ or similar Linux distribution
- At least 16GB RAM (32GB recommended)
- At least 400GB free disk space
- Python 3, Git, and build tools installed

## Setup Instructions

### 1. Install Required Packages

```bash
sudo apt-get update
sudo apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
```

### 2. Install Repo Tool

```bash
mkdir ~/bin
PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
```

### 3. Initialize AOSP Repository

```bash
mkdir aosp-android12-tv
cd aosp-android12-tv

# Initialize with Android 12.1.0 Release 27
repo init -u https://android.googlesource.com/platform/manifest -b android-12.1.0_r27

# Create local manifests directory
mkdir .repo/local_manifests

# Copy the device manifest
cp /path/to/this/repo/aosp_manifest.xml .repo/local_manifests/device.xml
```

### 4. Sync Repository

```bash
# Sync all repositories (this will take several hours)
repo sync -c -j$(nproc)
```

### 5. Setup Vendor Blobs

You'll need to extract or obtain proprietary vendor blobs for the Amlogic OHM device:

```bash
# If you have access to the proprietary files
git clone https://github.com/subjec2change/vendor_amlogic_ohm vendor/amlogic/ohm

# Or manually extract from device using the provided scripts
cd device/amlogic/ohm
./extract-files.sh
```

### 6. Build Android TV 12

```bash
# Setup build environment
source build/envsetup.sh

# Choose build target
lunch aosp_atv_generic-userdebug

# Start build (this will take several hours)
m -j$(nproc)
```

## Build Targets

- `aosp_atv_generic-eng` - Engineering build with additional debugging
- `aosp_atv_generic-userdebug` - User-debug build (recommended for development)
- `aosp_atv_generic-user` - Production user build

## Device Specifications

- **Platform**: Amlogic SC2
- **Architecture**: ARM 32-bit (ARMv7-A with NEON)
- **CPU**: Cortex-A55
- **Android Version**: 12 (API Level 31)
- **Target**: Android TV

## Output Files

After successful build, you'll find the following files in `out/target/product/generic/`:

- `system.img` - System partition image
- `vendor.img` - Vendor partition image
- `boot.img` - Boot image
- `recovery.img` - Recovery image
- `*.zip` - OTA update packages

## Flashing Instructions

Flash the built images using fastboot:

```bash
fastboot flash boot boot.img
fastboot flash system system.img
fastboot flash vendor vendor.img
fastboot reboot
```

## Troubleshooting

### Missing Dependencies
If you encounter missing dependencies, enable them in BoardConfig.mk:
```makefile
ALLOW_MISSING_DEPENDENCIES := true
```

### Vendor Blobs
Ensure all vendor blobs are properly extracted and placed in `vendor/amlogic/ohm/`. Check `proprietary-files.txt` for the complete list.

### Build Errors
- Increase swap space if you encounter out-of-memory errors
- Use `ccache` to speed up subsequent builds
- Check disk space - AOSP builds require significant storage

## Support

For issues specific to this device tree, please check the repository issues or create a new issue with:
- Full build log
- System specifications
- Steps to reproduce the problem