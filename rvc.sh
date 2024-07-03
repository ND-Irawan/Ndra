#!/bin/sh

DEFCONFIG="rvkernel/rvkernel_defconfig"
CLANGDIR="/root/clang"

#
rm -rf compile.log

#
mkdir -p out
mkdir out/RvKernel
mkdir out/RvKernel/NSE_Stock_old_driver
mkdir out/RvKernel/NSE_Stock_new_driver
mkdir out/RvKernel/NSE_800_old_driver
mkdir out/RvKernel/NSE_800_new_driver
mkdir out/RvKernel/NSE_835_old_driver
mkdir out/RvKernel/NSE_835_new_driver
mkdir out/RvKernel/SE_Stock_old_driver
mkdir out/RvKernel/SE_Stock_new_driver
mkdir out/RvKernel/SE_800_old_driver
mkdir out/RvKernel/SE_800_new_driver
mkdir out/RvKernel/SE_835_old_driver
mkdir out/RvKernel/SE_835_new_driver


#
export KBUILD_BUILD_USER=Radika
export KBUILD_BUILD_HOST=Rve27
export PATH="$CLANGDIR/bin:$PATH"

#
make O=out ARCH=arm64 $DEFCONFIG

#
MAKE="./makeparallel"

#
START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

rve () {
make -j$(nproc --all) O=out LLVM=1 \
ARCH=arm64 \
CC="ccache clang" \
LD=ld.lld \
AR=llvm-ar \
AS=llvm-as \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}

nse_stock_old_driver() {
cp RvKernel/NSE/* arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-9.1.24/* firmware/
rve 2>&1 | tee -a compile.log
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/NSE_Stock_old_driver/Image.gz-dtb
    fi
}

nse_stock_new_driver() {
cp RvKernel/NSE/* arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-10.3.7/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/NSE_Stock_new_driver/Image.gz-dtb
    fi
}

nse_800_old_driver() {
cp RvKernel/NSE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-9.1.24/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/NSE_800_old_driver/Image.gz-dtb
    fi
}

nse_800_new_driver() {
cp RvKernel/NSE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-10.3.7/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/NSE_800_new_driver/Image.gz-dtb
    fi
}

nse_835_old_driver() {
cp RvKernel/NSE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-9.1.24/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/NSE_835_old_driver/Image.gz-dtb
    fi
}

nse_835_new_driver() {
cp RvKernel/NSE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-10.3.7/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/NSE_835_new_driver/Image.gz-dtb
    fi
}

se_stock_old_driver() {
cp RvKernel/SE/* arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-9.1.24/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/SE_Stock_old_driver/Image.gz-dtb
    fi
}

se_stock_new_driver() {
cp RvKernel/SE/* arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/STOCK/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-10.3.7/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/SE_Stock_new_driver/Image.gz-dtb
    fi
}

se_800_old_driver() {
cp RvKernel/SE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-9.1.24/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/SE_800_old_driver/Image.gz-dtb
    fi
}

se_800_new_driver() {
cp RvKernel/SE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/800/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-10.3.7/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/SE_800_new_driver/Image.gz-dtb
    fi
}

se_835_old_driver() {
cp RvKernel/SE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-9.1.24/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/SE_835_old_driver/Image.gz-dtb
    fi
}

se_835_new_driver() {
cp RvKernel/SE/* arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
cp RvKernel/OC/835/gpucc-sdm845.c drivers/clk/qcom/
cp RvKernel/fw-touch-10.3.7/* firmware/
rve
    if [ $? -ne 0 ]
    then
        echo "Build failed"
    else
        echo "Build succesful"
        cp out/arch/arm64/boot/Image.gz-dtb out/RvKernel/SE_835_new_driver/Image.gz-dtb
    fi
}

nse_stock_old_driver
nse_stock_new_driver
nse_800_old_driver
nse_800_new_driver
nse_835_old_driver
nse_835_new_driver
se_stock_old_driver
se_stock_new_driver
se_800_old_driver
se_800_new_driver
se_835_old_driver
se_835_new_driver

END=$(date +"%s")
DIFF=$(($END - $START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
