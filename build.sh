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
export KERNEL_DEFCONFIG="gulch_defconfig"
export KERNEL_CMDLINE=
"ARCH=arm64
CC=clang
CROSS_COMPILE_COMPAT=aarch64-linux-android-
CROSS_COMPILE=aarch64-linux-gnu-
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
CLANG_TRIPLE=aarch64-linux-gnu-
READELF=llvm-readelf
LLVM_DIS=llvm-dis
AR=llvm-ar
NM=llvm-nm
OBJCOPY=llvm-objcopy
OBJDUMP=llvm-objdump
STRIP=llvm-strip
LLVM=1
LLVM_IAS=1
LD=ld.lld
HOSTCC=clang
HOSTCXX=clang++
O=out"
export PATH=$(pwd)/toolchains/neutron-clang/bin/:$PATH
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export KBUILD_BUILD_HOST="@beingsk5"
export BRAND_SHOW_FLAG=oneplus
export TARGET_PRODUCT=msmnile
# echo "CONFIG_BUILD_ARM64_DT_OVERLAY=y" >> gulch_defconfig

# Configure kernel     
cd kernel
make $KERNEL_CMDLINE CC="ccache clang" $KERNEL_DEFCONFIG
# | make O=out ARCH=arm64 olddefconfig

# Build kernel
make $KERNEL_CMDLINE CC="ccache clang" -j$(nproc --all)
