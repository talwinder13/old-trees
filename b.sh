#!/bin/bash


#For Time Calculation
BUILD_START=$(date +"%s")

kernel_version="v3"
kernel_name="Random_Kernel™"
device_name="Z2_Plus"
new_tree="New_Trees"
old_tree="Old_Trees"
treble="Treble"
zip_name="$kernel_name-$device_name-$treble-$(date +"%Y%m%d")-$(date +"%H%M%S").zip"

export HOME="/home/talwinder13"
export CONFIG_FILE="z2_plus_defconfig"
export ARCH="arm64"
export SUBARCH="arm64"
export KBUILD_BUILD_USER="talwinder13"
export KBUILD_BUILD_HOST="punjabi_ftw"
export CROSS_COMPILE="/home/talwinder13/linaro/bin/aarch64-linux-gnu-"
export CONFIG_ABS_PATH="arch/arm64/configs/${CONFIG_FILE}"
export outdir="$HOME/randomkernel/out"
export sourcedir="$HOME/randomkernel"
export zip="$HOME/randomkernel/zip"

compile() {
  make O=$outdir  $CONFIG_FILE -j12
  make O=$outdir -j12
}
clean() {
  make O=$outdir CROSS_COMPILE=${CROSS_COMPILE}  $CONFIG_FILE -j12
  make O=$outdir mrproper
  make O=$outdir clean
}
module_stock(){
  rm -rf $zip/modules/
  mkdir $zip/modules
  find $outdir -name '*.ko' -exec cp -av {} $zip/modules/ \;
  # strip modules
  ${CROSS_COMPILE}strip --strip-unneeded $zip/modules/*
  cp $outdir/arch/$ARCH/boot/Image.gz-dtb $zip/Image.gz-dtb
}
delete_zip(){
  cd $zip
  find . -name "*.zip" -type f
  find . -name "*.zip" -type f -delete
}
build_package(){
  zip -r9 UPDATE-zip2.zip * -x README UPDATE-zip2.zip
}
make_name(){
  mv UPDATE-zip2.zip $zip_name
}
turn_back(){
cd $sourcedir
}

clean
compile
module_stock
delete_zip
build_package
make_name
turn_back
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$blue Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
