download-y+=build
build-git:=https://android.googlesource.com/platform/build

PLATFORM_VERSION_CODENAME=REL
PLATFORM_VERSION=4.1.2
TARGET_PRODUCT=$(CONFIG_BOARD_NAME)
TARGET_BUILD_VARIANT=user
TARGET_BUILD_TYPE=release
TARGET_BUILD_APPS=
TARGET_ARCH=$(CONFIG_ARCH)
TARGET_ARCH_VARIANT=$(CONFIG_SUBARCH)
HOST_ARCH=$(shell uname -m)
HOST_OS=$(shell uname)
HOST_OS_EXTRA=$(shell uname -a)
HOST_BUILD_TYPE=release

TOPDIR?=$(root)
OUT_DIR:=out
BUILD_SYSTEM:=$(addprefix $(root)/,scripts/android/build/core)

ifneq ($(ONE_SHOT_MAKEFILE),)
include $(BUILD_SYSTEM)/main.mk
endif
