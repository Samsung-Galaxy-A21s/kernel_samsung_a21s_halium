#!/bin/bash
#
# Custom build script for Eureka kernels by Chatur27 and Gabriel260 @Github - 2020
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Set default directories
ROOT_DIR=$(pwd)
if [ ! -d "out" ]; then
	mkdir out
fi
OUT_DIR=$ROOT_DIR/out
KERNEL_DIR=$ROOT_DIR
DTB_DIR=arch/arm64/boot/dts/exynos
DTBO_DIR=arch/arm64/boot/dts/samsung/a21s

# Set default kernel variables
PROJECT_NAME="Halium Kernel"
CORES=$(nproc --all)
ZIPNAME=A217F_Halium_
DEFCONFIG=halium_defconfig

# Export commands
export VERSION=$DEFAULT_NAME
export ARCH=arm64
export CROSS_COMPILE=toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CC=toolchain/clang/host/linux-x86/clang-r353983c/bin/clang

# Get date and time
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

################### Executable functions #######################
CLEAN_SOURCE()
{
	echo "*****************************************************"
	echo " "
	echo "              Cleaning kernel source"
	echo " "
	echo "*****************************************************"
	make clean
	CLEAN_SUCCESS=$?
	if [ $CLEAN_SUCCESS != 0 ]
		then
			echo " Error: make clean failed"
			exit
	fi

	make mrproper
	MRPROPER_SUCCESS=$?
	if [ $MRPROPER_SUCCESS != 0 ]
		then
			echo " Error: make mrproper failed"
			exit
	fi

	if [ -e "flashZip/anykernel/Image" ]
	then
	  {
	     rm $DTB_DIR/*.dtb
	     rm $DTBO_DIR/*.dtbo
	     rm -rf flashZip/anykernel/Image
#	     rm -rf flashZip/anykernel/dtbo.img
	  }
	fi
	sleep 1	
}

BUILD_KERNEL()
{
	echo "*****************************************************"
	echo "           Building kernel for $DEVICE_Axxx          "
	export ANDROID_MAJOR_VERSION=$ANDROID
	export LOCALVERSION=-$VERSION
	make  $DEFCONFIG
	make -j$CORES
	sleep 1	
}

AUTO_TOOLCHAIN()
{
	     echo " "
	     echo "Using GCC v4.9 toolchain"
	     echo " "
	     export CROSS_COMPILE=toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
	     export CC=toolchain/clang/host/linux-x86/clang-r353983c/bin/clang
}

ZIPPIFY()
{
	# Make Eureka flashable zip
	
	if [ -e "arch/$ARCH/boot/Image" ]
	then
	{
		echo -e "*****************************************************"
		echo -e "                                                     "
		echo -e "       Building Eureka anykernel flashable zip       "
		echo -e "                                                     "
		echo -e "*****************************************************"
		
		# Copy Image and dtbo.img to anykernel directory
		cp -f arch/$ARCH/boot/Image flashZip/anykernel/Image
#		cp -f arch/$ARCH/boot/dtbo.img flashZip/anykernel/dtbo.img       dtbo does not get appeneded to kernel for A217f
		
		# Go to anykernel directory
		cd flashZip/anykernel
		zip -r9 $ZIPNAME * -x .git README.md *placeholder
#		zip -r9 $ZIPNAME META-INF modules patch ramdisk tools anykernel.sh Image dtbo.img version
		chmod 0777 $ZIPNAME
		# Change back into kernel source directory
		cd ..
		sleep 1
		cd ..
		sleep 1
	}
	fi
}

ENTER_VERSION()
{
	# Enter kernel revision for this build.
	read -p "Please type kernel version without R (E.g: 4.7) : " rev;
	if [ "${rev}" == "" ]; then
		echo " "
		echo "     Using '$REV' as version"
	else
		REV=$rev
		echo " "
		echo "     Version = $REV"
	fi
	sleep 2
}

RENAME()
{
	# Give proper name to kernel and zip name
	ZIPNAME=$ZIPNAME"_"$TYPE"_"$REV".zip"
}

DISPLAY_ELAPSED_TIME()
{
	# Find out how much time build has taken
	BUILD_END=$(date +"%s")
	DIFF=$(($BUILD_END - $BUILD_START))

	BUILD_SUCCESS=$?
	if [ $BUILD_SUCCESS != 0 ]
		then
			echo " Error: Build failed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
			exit
	fi
	
	echo -e "                     Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
	sleep 1
}

COMMON_STEPS()
{
	echo "*****************************************************"
	echo "                                                     "
	echo "        Starting compilation of $DEVICE_Axxx kernel  "
	echo "                                                     "
	echo " Defconfig = $DEFCONFIG                              "
	echo "                                                     "
	echo "*****************************************************"
	RENAME
	sleep 1
	echo " "	
	BUILD_KERNEL
	echo " "
	sleep 1
	ZIPPIFY
	sleep 1
	echo " "
	DISPLAY_ELAPSED_TIME
	echo " "
	echo "                 *****************************************************"
	echo "*****************                                                     *****************"
	echo "                      build finished          "
	echo "*****************                                                     *****************"
	echo "                 *****************************************************"
}


#################################################################


###################### Script starts here #######################

AUTO_TOOLCHAIN
CLEAN_SOURCE
ENTER_VERSION
COMMON_STEPS
