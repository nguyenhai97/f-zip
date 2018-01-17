#!/bin/bash

#
# F-zip: Universal recovery flashable zip generator for Linux & android
# 
# Author: sunilpaulmathew <sunil.kde@gmail.com>
#
# Version 2.1.0
#

# This script is licensed under the terms of the GNU General Public License version 2, as published by the 
# Free Software Foundation, and may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#

#
# ***** ***** *Variables to be configured manually* ***** ***** #
#

PROJECT_NAME="project-name"		# please-enter-without-space.

PROJECT_VERSION="project-version"	# please-enter-without-space. 
					# If the above two left as such, it will display "Flashing project-name v. project-version"

COPYRIGHT="copyright"			# If left as such, it will display "(c) copyright"

BOOT_PARTITION="/dev/block/platform/msm_sdcc.1/by-name/boot"	# Please provide exact path to the boot partition of your device

# Please provide the exact system/app(s) name(s) (should be case sensitive). Please leave as such (APP1="") if you do not have a “folder” to be added to "system/app"
APP1=""
APP2=""
APP3=""
APP4=""
APP5=""

APP=""			# Please enter y (APP="y") if you want to add an app(s) directly to "/system/app/" (without a separate folder).

# Please provide the exact system/priv-app(s) name(s) (should be case sensitive). Please leave as such (PRIV_APP1="") if you do not have a “folder” to be added to "system/priv-app"
PRIV_APP1=""
PRIV_APP2=""
PRIV_APP3=""
PRIV_APP4=""
PRIV_APP5=""

PRIV_APP=""		# Please enter y (APP="y") if you want to add an app(s) directly to "/system/priv-app/" (without a separate folder).

LIBRARY=""		# Please enter y (LIBRARY="y") if you want to add ".so" file(s) to "/system/lib/"

MODULES=""		# Please enter y (MODULES="y") if you want to add ".ko" file(s) to "/system/lib/modules/"

FRAMEWORK=""		# Please enter y (FRAMEWORK="y") if you want to add ".jar" file(s) to "/system/framework/"

DEV_MSG=""		# Please enter n (DEV_MSG="n"), if you want to hide thanks message from the developer.

#
# ***** ***** ***** ***** ***THE END*** ***** ***** ***** ***** #
#

#
# System variables. Please do not touch unless you know what you are doing... 
#

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"
PROJECT_ROOT=$PWD

echo -e $COLOR_GREEN"\n F-zip: Universal recovery flashable zip generator for Linux & android\n"$COLOR_GREEN
#
echo -e $COLOR_GREEN"\n (c) sunilpaulmathew@xda-developers.com\n"$COLOR_GREEN

# backing up original updater-script...

cp $PROJECT_ROOT/META-INF/com/google/android/updater-script $PROJECT_ROOT/backup.sh

DISPLAY_NAME="Flashing $PROJECT_NAME v. $PROJECT_VERSION"

OUTPUT_FILE="$PROJECT_NAME-v.$PROJECT_VERSION-$(date +"%Y%m%d").zip"

sed -i "s;###Flashing###;${DISPLAY_NAME};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
sed -i "s;###copyright###;(c) ${COPYRIGHT};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;

# dev msg

if [ "n" == "$DEV_MSG" ]; then
	sed -i "s;ui_print-devmsg1;# ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;ui_print-devmsg2;# ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
else
	sed -i "s;ui_print-devmsg1;ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;ui_print-devmsg2;ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
fi

# check and create “system” folder.

if [ ! -d "$PROJECT_ROOT/system/" ]; then
	mkdir $PROJECT_ROOT/system/
fi

# modifying updater script...

# system-app(s)

if [ "y" == "$APP" ]; then
	sed -i "s;# set_perm_sysapp;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ ! -d "$PROJECT_ROOT/system/app/" ]; then
		mkdir $PROJECT_ROOT/system/app/
	fi
	echo -e $COLOR_GREEN"\n copying app(s) to 'system/app/' directory... \n"$COLOR_GREEN
	cp $PROJECT_ROOT/working/app/* $PROJECT_ROOT/system/app/
fi

if [ -z "$APP1" ]; then
	sed -i "s;set_perm_app1;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_app1;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-app1;/system/app/${APP1};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-apk1;/system/app/${APP1}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/app/$APP1 ]; then
		if [ ! -d "$PROJECT_ROOT/system/app/" ]; then
			mkdir $PROJECT_ROOT/system/app/
		fi
		echo -e $COLOR_GREEN"\n copying '$APP1' to 'system/app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/app/$APP1/ $PROJECT_ROOT/system/app/
	else
		echo -e $COLOR_RED"\n Warning! '$APP1', which is designated as ‘APP1’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$APP2" ]; then
	sed -i "s;set_perm_app2;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_app2;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-app2;/system/app/${APP2};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-apk2;/system/app/${APP2}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/app/$APP2 ]; then
		if [ ! -d "$PROJECT_ROOT/system/app/" ]; then
			mkdir $PROJECT_ROOT/system/app/
		fi
		echo -e $COLOR_GREEN"\n copying '$APP2' to 'system/app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/app/$APP2 $PROJECT_ROOT/system/app/
	else
		echo -e $COLOR_RED"\n Warning! '$APP2', which is designated as ‘APP2’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$APP3" ]; then
	sed -i "s;set_perm_app3;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_app3;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-app3;/system/app/${APP3};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-apk3;/system/app/${APP3}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/app/$APP3 ]; then
		if [ ! -d "$PROJECT_ROOT/system/app/" ]; then
			mkdir $PROJECT_ROOT/system/app/
		fi
		echo -e $COLOR_GREEN"\n copying '$APP3' to 'system/app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/app/$APP3 $PROJECT_ROOT/system/app/
	else
		echo -e $COLOR_RED"\n Warning! '$APP3', which is designated as ‘APP3’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$APP4" ]; then
	sed -i "s;set_perm_app4;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_app4;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-app4;/system/app/${APP4};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-apk4;/system/app/${APP4}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/app/$APP4 ]; then
		if [ ! -d "$PROJECT_ROOT/system/app/" ]; then
			mkdir $PROJECT_ROOT/system/app/
		fi
		echo -e $COLOR_GREEN"\n copying '$APP4' to 'system/app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/app/$APP4 $PROJECT_ROOT/system/app/
	else
		echo -e $COLOR_RED"\n Warning! '$APP4', which is designated as ‘APP4’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$APP5" ]; then
	sed -i "s;set_perm_app5;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_app5;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-app5;/system/app/${APP5};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;main-apk5;/system/app/${APP5}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/app/$APP5 ]; then
		if [ ! -d "$PROJECT_ROOT/system/app/" ]; then
			mkdir $PROJECT_ROOT/system/app/
		fi
		echo -e $COLOR_GREEN"\n copying '$APP5' to 'system/app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/app/$APP5 $PROJECT_ROOT/system/app/
	else
		echo -e $COLOR_RED"\n Warning! '$APP5', which is designated as ‘APP5’ does not exist... \n"$COLOR_RED
	fi
fi

# priv-app(s)

if [ "y" == "$PRIV_APP" ]; then
	sed -i "s;# set_perm_privapp;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ ! -d "$PROJECT_ROOT/system/priv-app/" ]; then
		mkdir $PROJECT_ROOT/system/priv-app/
	fi
	echo -e $COLOR_GREEN"\n copying apps to 'system/priv-app/' directory... \n"$COLOR_GREEN
	cp $PROJECT_ROOT/working/priv-app/* $PROJECT_ROOT/system/priv-app/
fi

if [ -z "$PRIV_APP1" ]; then
	sed -i "s;set_perm_priv1;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_priv1;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-app1;/system/priv-app/${PRIV_APP1};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-apk1;/system/priv-app/${PRIV_APP1}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/priv-app/$PRIV_APP1 ]; then
		if [ ! -d "$PROJECT_ROOT/system/priv-app/" ]; then
			mkdir $PROJECT_ROOT/system/priv-app/
		fi
		echo -e $COLOR_GREEN"\n copying '$PRIV_APP1' to 'system/priv-app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/priv-app/$PRIV_APP1 $PROJECT_ROOT/system/priv-app/
	else
		echo -e $COLOR_RED"\n Warning! '$PRIV_APP1', which is designated as ‘PRIV_APP1’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$PRIV_APP2" ]; then
	sed -i "s;set_perm_priv2;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_priv2;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-app2;/system/priv-app/${PRIV_APP2};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-apk2;/system/priv-app/${PRIV_APP2}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/priv-app/$PRIV_APP2 ]; then
		if [ ! -d "$PROJECT_ROOT/system/priv-app/" ]; then
			mkdir $PROJECT_ROOT/system/priv-app/
		fi
		echo -e $COLOR_GREEN"\n copying '$PRIV_APP2' to 'system/priv-app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/priv-app/$PRIV_APP2 $PROJECT_ROOT/system/priv-app/
	else
		echo -e $COLOR_RED"\n Warning! '$PRIV_APP2', which is designated as ‘PRIV_APP2’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$PRIV_APP3" ]; then
	sed -i "s;set_perm_priv3;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_priv3;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-app3;/system/priv-app/${PRIV_APP3};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-apk3;/system/priv-app/${PRIV_APP3}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/priv-app/$PRIV_APP3 ]; then
		if [ ! -d "$PROJECT_ROOT/system/priv-app/" ]; then
			mkdir $PROJECT_ROOT/system/priv-app/
		fi
		echo -e $COLOR_GREEN"\n copying '$PRIV_APP3' to 'system/priv-app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/priv-app/$PRIV_APP3 $PROJECT_ROOT/system/priv-app/
	else
		echo -e $COLOR_RED"\n Warning! '$PRIV_APP3', which is designated as ‘PRIV_APP3’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$PRIV_APP4" ]; then
	sed -i "s;set_perm_priv4;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_priv4;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-app4;/system/priv-app/${PRIV_APP4};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-apk4;/system/priv-app/${PRIV_APP4}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/priv-app/$PRIV_APP4 ]; then
		if [ ! -d "$PROJECT_ROOT/system/priv-app/" ]; then
			mkdir $PROJECT_ROOT/system/priv-app/
		fi
		echo -e $COLOR_GREEN"\n copying '$PRIV_APP4' to 'system/priv-app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/priv-app/$PRIV_APP4 $PROJECT_ROOT/system/priv-app/
	else
		echo -e $COLOR_RED"\n Warning! '$PRIV_APP4', which is designated as ‘PRIV_APP4’ does not exist... \n"$COLOR_RED
	fi
fi

if [ -z "$PRIV_APP5" ]; then
	sed -i "s;set_perm_priv5;# set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;		
else
	sed -i "s;set_perm_priv5;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-app5;/system/priv-app/${PRIV_APP5};" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;priv-apk5;/system/priv-app/${PRIV_APP5}/*;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ -d $PROJECT_ROOT/working/priv-app/$PRIV_APP5 ]; then
		if [ ! -d "$PROJECT_ROOT/system/priv-app/" ]; then
			mkdir $PROJECT_ROOT/system/priv-app/
		fi
		echo -e $COLOR_GREEN"\n copying '$PRIV_APP5' to 'system/priv-app/' directory... \n"$COLOR_GREEN
		cp -r $PROJECT_ROOT/working/priv-app/$PRIV_APP5 $PROJECT_ROOT/system/priv-app/
	else
		echo -e $COLOR_RED"\n Warning! '$PRIV_APP5', which is designated as ‘PRIV_APP5’ does not exist... \n"$COLOR_RED
	fi
fi

# framework

if [ -e $PROJECT_ROOT/working/framework/framework-res.apk ]; then
	if [ "y" == "$FRAMEWORK" ]; then
		sed -i "s;# set_perm-fwr;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# set_perm_jar;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		if [ ! -d "$PROJECT_ROOT/system/framework/" ]; then
			mkdir $PROJECT_ROOT/system/framework/
		fi
		echo -e $COLOR_GREEN"\n copying 'framework-res.apk' & other framework (.jar) files into 'system/framework/' directory... \n"$COLOR_GREEN
		cp $PROJECT_ROOT/working/framework/* $PROJECT_ROOT/system/framework/
	else
		sed -i "s;# set_perm-fwr;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		if [ ! -d "$PROJECT_ROOT/system/framework/" ]; then
			mkdir $PROJECT_ROOT/system/framework/
		fi
			echo -e $COLOR_GREEN"\n copying 'framework-res.apk' to 'system/framework/' directory... \n"$COLOR_GREEN
			cp $PROJECT_ROOT/working/framework/framework-res.apk $PROJECT_ROOT/system/framework/
	fi
else
	if [ "y" == "$FRAMEWORK" ]; then
		sed -i "s;# set_perm_jar;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		echo -e $COLOR_GREEN"\n copying framework (.jar) files to 'system/framework/' directory... \n"$COLOR_GREEN
		if [ ! -d "$PROJECT_ROOT/system/framework/" ]; then
			mkdir $PROJECT_ROOT/system/framework/
		fi
		cp $PROJECT_ROOT/working/framework/* $PROJECT_ROOT/system/framework/
	fi
fi

# lib
if [ "y" == "$LIBRARY" ]; then
	sed -i "s;# set_perm_lib;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ ! -d "$PROJECT_ROOT/system/lib/" ]; then
		mkdir $PROJECT_ROOT/system/lib/
	fi
	echo -e $COLOR_GREEN"\n copying library (.so) files to 'system/lib/' directory... \n"$COLOR_GREEN
	cp $PROJECT_ROOT/working/lib/* $PROJECT_ROOT/system/lib/
fi

# modules

if [ "y" == "$MODULES" ]; then
	sed -i "s;# set_perm_modules;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ ! -d "$PROJECT_ROOT/system/lib/modules/" ]; then
		mkdir $PROJECT_ROOT/system/lib/modules/
	fi
	echo -e $COLOR_GREEN"\n copying modules (.ko) to 'system/lib/modules/' directory... \n"$COLOR_GREEN
	cp $PROJECT_ROOT/working/modules/* $PROJECT_ROOT/system/lib/modules/
fi

# boot-animation

if [ -e $PROJECT_ROOT/working/bootanimation.zip ]; then
	sed -i "s;# set_perm-bootanimation;set_perm;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	if [ ! -d "$PROJECT_ROOT/system/media/" ]; then
		mkdir $PROJECT_ROOT/system/media/
	fi
	echo -e $COLOR_GREEN"\n copying 'bootanimation.zip' to 'system/media/' directory... \n"$COLOR_GREEN
	if [ ! -d "$PROJECT_ROOT/system/media/" ]; then
		mkdir $PROJECT_ROOT/system/media/
	fi
	cp $PROJECT_ROOT/working/bootanimation.zip $PROJECT_ROOT/system/media/
fi

# boot.img

if [ -e $PROJECT_ROOT/working/boot.img ]; then
	if [ -z "$BOOT_PARTITION" ]; then
		mv $PROJECT_ROOT/working/boot.img $PROJECT_ROOT/boot.sh
		echo -e $COLOR_GREEN"\n Error found. Please check line# 30\n"$COLOR_NEUTRAL
		echo -e $COLOR_GREEN"\n 'boot.img' is excluded from the $OUTPUT_FILE \n"$COLOR_GREEN
	else
		echo -e $COLOR_GREEN"\n copying 'boot.img' to root directory... \n"$COLOR_GREEN
		cp $PROJECT_ROOT/working/boot.img $PROJECT_ROOT/
		sed -i "s;boot-partition;$BOOT_PARTITION;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# ui_print-boot;ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# package_extract_file-boot;package_extract_file;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# run_program-system;run_program;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# run_program-data;run_program;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# run_program-cache;run_program;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# unmount-data;unmount;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# unmount-system;unmount;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
		sed -i "s;# run_program-sync;run_program;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	fi
fi

# dev msg

if [ "n" == "$DEV_MSG" ]; then
	sed -i "s;ui_print-devmsg1;# ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;ui_print-devmsg2;# ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
else
	sed -i "s;ui_print-devmsg1;ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
	sed -i "s;ui_print-devmsg2;ui_print;" $PROJECT_ROOT/META-INF/com/google/android/updater-script;
fi

# generating recovery flashable zip file

if [ ! -d "$PROJECT_ROOT/output/" ]; then
	mkdir $PROJECT_ROOT/output/
fi

if [ -z "$(ls -A system/)" ]; then
	if [ -e $PROJECT_ROOT/boot.img ]; then
		zip -r9 --exclude=*placeholder* $PROJECT_ROOT/output/$OUTPUT_FILE META-INF/* boot.img
	else
		echo -e $COLOR_RED"\n nothing done… ‘working’ directory is empty... \n"$COLOR_RED
	fi
else
	if [ -e $PROJECT_ROOT/boot.img ]; then
		zip -r9 --exclude=*placeholder* $PROJECT_ROOT/output/$OUTPUT_FILE META-INF/* system/* boot.img
	else
		zip -r9 --exclude=*placeholder* $PROJECT_ROOT/output/$OUTPUT_FILE META-INF/* system/*
	fi	
fi

# restoring backup(s)...

if [ -e $PROJECT_ROOT/boot.sh ]; then
		mv $PROJECT_ROOT/boot.sh $PROJECT_ROOT/working/boot.img
fi

mv $PROJECT_ROOT/backup.sh $PROJECT_ROOT/META-INF/com/google/android/updater-script

# cleaning

if [ -e $PROJECT_ROOT/boot.img ]; then
	rm $PROJECT_ROOT/boot.img
fi

if [ -e $PROJECT_ROOT/system/ ]; then
	rm -r $PROJECT_ROOT/system/
fi

# THE END
