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

# Set default kernel variables
PROJECT_NAME="Halium Kernel"
ZIPNAME=A217F_Halium
DEFCONFIG=halium_defconfig

# Export commands
export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s
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

	if [ -e "Halium/packaging/boot.img" ]
	then
	  {
	     rm -rf Halium/packaging/boot.img
	  }
	fi
	if [ -e "Halium/packaging/A217F_Halium.zip"]
	then
	  {
	     rm -rf Halium/packaging/A217_Halium.zip
	  }
	fi
	sleep 1	
}

BUILD_KERNEL()
{
	echo "*****************************************************"
	echo "           Building kernel for SM-A217F          "
	make ARCH=arm64 $DEFCONFIG
	make ARCH=arm64 -j 64
	sleep 1	
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


RENAME()
{
	# Give proper name to kernel and zip name
	ZIPNAME=$ZIPNAME".zip"
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

COMMON_STEPS
