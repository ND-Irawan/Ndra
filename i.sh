#!/bin/bash
#set -e
## Copy this script inside the kernel directory
export PATH="$MAIN/clang/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64
CLANGDIR="/workspace/build/clang"

rm -rf out
rm -rf compile.log

mkdir -p out
mkdir out/Ndra

export KBUILD_BUILD_USER=ND
export KBUILD_BUILD_HOST=Irawan

# Function to revert modifications

revert_modifications() {
  if [ "$choice" = "miui" ]; then
    if [ "$device" = "apollo" ]; then
      sed -i 's/qcom,mdss-pan-physical-width-dimension = <700>;$/qcom,mdss-pan-physical-width-dimension = <70>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-j3s-37-02-0a-dsc-video.dtsi
      sed -i 's/qcom,mdss-pan-physical-height-dimension = <1540>;$/qcom,mdss-pan-physical-height-dimension = <155>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-j3s-37-02-0a-dsc-video.dtsi
    elif [ "$device" = "alioth" ]; then
      sed -i 's/qcom,mdss-pan-physical-width-dimension = <700>;$/qcom,mdss-pan-physical-width-dimension = <70>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-k11a-38-08-0a-dsc-cmd.dtsi
      sed -i 's/qcom,mdss-pan-physical-height-dimension = <1540>;$/qcom,mdss-pan-physical-height-dimension = <155>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-k11a-38-08-0a-dsc-cmd.dtsi
    fi
  fi
  git checkout arch/arm64/boot/dts/vendor/qcom/dsi-panel-* &>/dev/null
}


echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"

# Prompt for device choice
read -p "Choose device (apollo/alioth): " device
if [ "$device" = "apollo" ]; then
  KERNEL_DEFCONFIG=apollo_defconfig
  DEVICE_NAME1="apollo"
  DEVICE_NAME2="apollon"
  IS_SLOT_DEVICE=0
  
  # Remove vendor_boot block for apollo
  VENDOR_BOOT_LINES_REMOVED=1
else
  KERNEL_DEFCONFIG=alioth_defconfig
  DEVICE_NAME1="alioth"
  DEVICE_NAME2="aliothin"
  IS_SLOT_DEVICE=1
  VENDOR_BOOT_LINES_REMOVED=0
fi

# Prompt for MIUI or AOSP
read -p "Do you want MIUI or AOSP? (miui/aosp): " choice
if [ "$choice" = "miui" ]; then
  # Modify the dimensions for MIUI
  if [ "$device" = "apollo" ]; then
    sed -i 's/qcom,mdss-pan-physical-width-dimension = <70>;$/qcom,mdss-pan-physical-width-dimension = <700>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-j3s-37-02-0a-dsc-video.dtsi
    sed -i 's/qcom,mdss-pan-physical-height-dimension = <155>;$/qcom,mdss-pan-physical-height-dimension = <1540>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-j3s-37-02-0a-dsc-video.dtsi
  elif [ "$device" = "alioth" ]; then
    sed -i 's/qcom,mdss-pan-physical-width-dimension = <70>;$/qcom,mdss-pan-physical-width-dimension = <700>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-k11a-38-08-0a-dsc-cmd.dtsi
    sed -i 's/qcom,mdss-pan-physical-height-dimension = <155>;$/qcom,mdss-pan-physical-height-dimension = <1540>;/' arch/arm64/boot/dts/vendor/qcom/dsi-panel-k11a-38-08-0a-dsc-cmd.dtsi
  fi
fi

# kernel-Compilation

make $KERNEL_DEFCONFIG O=out CC=clang
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

nd 2>&1 | tee -a compile.log

# Revert changes back to the original state
revert_modifications
