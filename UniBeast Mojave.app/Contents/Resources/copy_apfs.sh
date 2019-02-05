#!/bin/bash
#
# Script for copying apfs.efi to destination
#
# Return Codes:
#
#	0 - Copy was successful
#	1 - Copy failed
#	2 - Unable to attach BaseSystem.dmg
#   3 - Unable to detach BaseSystem.dmg
#
# Copyright (C) tonymacx86 LLC

mode=$1
MBR=`diskutil list "Install macOS Mojave" | grep -c FDisk_partition_scheme`

if hdiutil attach -quiet -nobrowse /Applications/Install\ macOS\ Mojave.app/Contents/SharedSupport/BaseSystem.dmg  ; then

	case "$mode" in 
		UEFI )	
			if ! cp /Volumes/OS\ X\ Base\ System/usr/standalone/i386/apfs.efi /Volumes/ESP/EFI/CLOVER/drivers64UEFI/ ; then
				exit 1
			fi
			;;
		Legacy ) 
			if [ $MBR -eq 1 ]; then
				if ! cp /Volumes/OS\ X\ Base\ System/usr/standalone/i386/apfs.efi /Volumes/Install\ macOS\ Mojave/EFI/CLOVER/drivers64/ ; then
					exit 1
				fi
			else
				if ! cp /Volumes/OS\ X\ Base\ System/usr/standalone/i386/apfs.efi /Volumes/ESP/EFI/CLOVER/drivers64/ ; then
					exit 1
				fi
			fi ;;
	esac
	
	if hdiutil detach -quiet /Volumes/OS\ X\ Base\ System/ ; then
		exit 0
	else
		exit 3
	fi
	
else
	exit 2
fi
