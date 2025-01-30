#!/bin/sh
CLANGDIR="/workspace/build/clang"

rm -rf out
rm -rf compile.log

mkdir -p out
mkdir out/Ndra

export KBUILD_BUILD_USER=ND
export KBUILD_BUILD_HOST=Irawan
export PATH="$CLANGDIR/bin:$PATH"

make O=out ARCH=arm64 alioth_defconfig

nd () {
make -j$(nproc --all) O=out LLVM=1 LLVM_IAS=1 \
ARCH=arm64 \
CC=clang \
LD=ld.lld \
AR=llvm-ar \
AS=llvm-as \
NM=llvm-nm \
STRIP=llvm-strip \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
READELF=llvm-readelf \
HOSTCC=clang \
HOSTCXX=clang++ \
HOSTAR=llvm-ar \
HOSTLD=ld.lld \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}

nd 2>&1 | tee -a compile.log
