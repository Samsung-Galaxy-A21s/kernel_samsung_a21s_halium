#!/bin/bash

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
}

CLEAN_PACKAGES()
{

	if [ ! -e "out" ]
	then
	  {
	     mkdir out
	  }
	fi

	if [ -e "Halium/packaging/boot.img" ]
	then
	  {
	     rm -rf Halium/packaging/boot.img
	  }
	fi
	if [ -e "Halium/packaging/A217F_Halium.zip" ]
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
	make ARCH=arm64 $DEFCONFIG O=$(pwd)/out
	make ARCH=arm64 -j64 O=$(pwd)/out
	sleep 1	
}


AIK-Linux()
{
	# Building boot image with AIK-Linux
	
	if [ -e "out/arch/$ARCH/boot/Image" ]
	then
	{
		echo -e "*****************************************************"
		echo -e "                                                     "
		echo -e "       Building flashable boot image...              "
		echo -e "                                                     "
		echo -e "*****************************************************"
		
		# Copy Image to AIK Directory
		cd Halium/AIK-Linux
		./unpackimg.sh
		rm -rf split-img/boot.img-kernel
		cp -f ../../out/arch/$ARCH/boot/Image split_img/boot.img-kernel
		./repackimg.sh
		cp -f image-new.img ../packaging/boot.img
		./cleanup.sh

		# Go to anykernel directory
		cd ../packaging
		zip -r9 $ZIPNAME * -x .git README.md
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
	CLEAN_PACKAGES
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
	AIK-Linux
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
