# Halium Kernel Source for SM-A217F/M
**Based on A217FXXS8DWC2**

## About
The goal of Halium is to unify the Hardware Abstraction Layer for projects which run GNU/Linux on mobile devices.
As the goal of the Halium project is to boot Linux systems on mobile devices lots of config and security changes
have been made, meaning that Stock Android will not be compatible with the latest release. Therefore I have 
tested this kernel with a variety of GSI's and they all seem to boot fine. Hopefully i will soon be able to 
develop a Droidian OS port so A21s users can get the full GNU/Linux experience on there phone.
 
## Features

**Compiler**
* GCC v4.9 Toolchain, with clang
* Building time optimisations
* Exynos 3830 optimization flags

**General**
* Samsung Security Disabled
* Halium Compliant config
* SELinux permissive
* Disabled uneeded USB drivers
* Halium security Enabled
	- AppArmor
	- TOMOYO
	- YAMA
* Disabled uneeded FSystems
* Underclocked and overclocked some CPU cores.

**Battery savings**
* Work in progress...

## Download
* [Halium A12](https://github.com/Samsung-Galaxy-A21s/kernel_samsung_a21s_halium/releases/latest)

## Installation
* Make sure to enabled OEM unlocking and USB debugging in settings
* Open Odin on your computer and boot the phone into download mode
* Flash patched vbmeta.img for the S8 in Odin AP slot [VBMETA](https://drive.google.com/file/d/1OczSbdScy6kL9nxjoZg__7b_Gz949jQf/view?usp=sharing) *This will be different for other binary's*
* Flash this in Odin AP slot [TWRP](https://github.com/DozNaka/android_device_samsung_a21s/releases)
* Boot into recovery mode from download mode by pressing, Volume Up + Power Button
* Go to, Wipe -> format data -> yes, then reboot back to recovery
* Go to Terminal and type: $ multidisabler  :then reboot to recovery
* Press adb sideload option
* Run the command $ adb sideload "A217F-Halium.zip" using [SDK Tools](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)
* Then reboot to system and enjoy Halium!!

## Credits

* Big thanks to arpio's halium port for the [a20](https://gitlab.com/arpio/kernel_samsung_a20_halium), on which the a21s port is heavily based on.
* Credit to [physwizz](https://github.com/physwizz) for the CPU overclocking and underclocking code.
* Credit to [Osmosis](https://github.com/osm0sis) for the Android Image Kitchen tools
