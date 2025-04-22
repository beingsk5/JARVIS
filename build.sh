#!/bin/bash

# Usage: ./build.sh <device_codename>

DEVICE_CODENAME=$1
 
if [ -z "$DEVICE_CODENAME" ]; then
    echo "Error: Device codename not provided"
    echo "Usage: ./build.sh <device_codename>"
    exit 1
fi

cd kernel

# Export required variables
export PATH=$(pwd)/toolchains/neutron-clang/bin/:$PATH
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export CCACHE_EXEC=$(which ccache)
export KBUILD_BUILD_HOST="@beingsk5"
export LLVM=1
export LLVM_IAS=1
echo "CONFIG_BUILD_ARM64_DT_OVERLAY=y" >> gulch_defconfig

# Configure kernel     
make O=out ARCH=arm64 gulch_defconfig 
# | make O=out ARCH=arm64 olddefconfig

# Build kernel
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="ccache clang" \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    LLVM_IAS=1 \
    LLVM=1 \
    STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    CROSS_COMPILE_COMPAT=arm-linux-androidkernel-
