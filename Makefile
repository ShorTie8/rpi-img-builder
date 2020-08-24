# menu
MENU=./lib/menu
CONF=./lib/config
ADMIN=./lib/admin_config
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFS=./scripts/rootfs
ROOTFS=sudo ./scripts/rootfs

# aarch64
BCM2711=./scripts/linux

# stages
IMG=./scripts/raspberrypi-stage1
IMAGE=sudo ./scripts/raspberrypi-stage1
STG2=./scripts/raspberrypi-stage2

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# help
HELPER=./scripts/help

help:
	@echo
	@echo "Debian Image Builder for the Raspberry Pi"
	@echo
	@echo "Usage: "
	@echo
	@echo "  make ccompile          Install all dependencies"
	@echo "  make ncompile          Install native dependencies"
	@echo "  make config            Create user data file"
	@echo "  make menu              User menu interface"
	@echo "  make cleanup           Clean up image errors"
	@echo "  make purge             Remove tmp directory"
	@echo "  make commands          List legacy commands"
	@echo
	@echo "For details consult the README.md"
	@echo

commands:
	@echo
	@echo "Boards:"
	@echo
	@echo "  bcm2711                 Raspberry Pi 4B"
	@echo
	@echo "bcm2711:"
	@echo " "
	@echo "  make kernel             Builds linux kernel"
	@echo "  make image              Make bootable Debian image"
	@echo "  make all                Kernel > rootfs > image"
	@echo
	@echo "Root filesystem:"
	@echo
	@echo "  make rootfs		 armhf arm64"
	@echo
	@echo "Miscellaneous:"
	@echo
	@echo "  make dialogrc		 Set builder theme"
	@echo "  make helper		 Reduce the time it takes to create a new image"
	@echo

# arm64 armv7l
ccompile:
	# Install all dependencies:
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-arm64 crossbuild-essential-armhf

ncompile:
	# Install all dependencies:
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig

# Raspberry Pi 4
kernel:
	# Linux
	@chmod +x ${BCM2711}
	@${BCM2711}

image:
	# Making bootable Debian image
	@ echo bcm2711 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

all:
	# Raspberry Pi 4B
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${BCM2711}
	@${BCM2711}
	# Creating ROOTFS tarball
	@chmod +x ${RFS}
	@${ROOTFS}
	# Making bootable Debian image
	@ echo bcm2711 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

# rootfs
rootfs:
	# DEBIAN ROOTFS
	@chmod +x ${RFS}
	@${ROOTFS}

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing tmp directory
	sudo rm -fdr rpi*

# menu
menu:
	# User menu interface
	@chmod +x ${MENU}
	@${MENU}
config:
	# User config menu
	@chmod +x ${CONF}
	@${CONF}

admin:
	# User config menu
	@chmod +x ${ADMIN}
	@${ADMIN}

dialogrc:
	# Builder theme set
	@${DIALOGRC}

helper:
	# Helper script
	@chmod +x ${HELPER}
	@${HELPER} -h

2711:
	# BCM2711
	@chmod +x ${HELPER}
	@${HELPER} -4
