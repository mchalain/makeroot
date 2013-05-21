CROSS_COMPILE := $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH := $(CONFIG_ARCH:"%"=%)
export CROSS_COMPILE ARCH

bootdir:=$(objtree)/boot
uImage:=arch/$(ARCH)/boot/uImage 

makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)


ifeq ($(CONFIG_LINUX_LINARO), y)
target=linux-linaro
ifeq ($(CONFIG_LINUX_LINARO_TRACKING), y)
CONFIG_KERNEL_VERSION:=tracking
else
linaro-release=$(CONFIG_LINUX_LINARO_RELEASE_Y).$(CONFIG_LINUX_LINARO_RELEASE_M)
ifeq ($(linaro-release), 13.02)
CONFIG_KERNEL_VERSION:=3.8$(linaro-release:%=-20%)
endif
ifeq ($(linaro-release), 13.03)
CONFIG_KERNEL_VERSION:=3.9-rc3$(linaro-release:%=-20%)
endif
ifeq ($(linaro-release), 13.04)
CONFIG_KERNEL_VERSION:=3.9-rc7$(linaro-release:%=-20%)
endif
endif
else
target=linux
endif
$(target)-version:=$(CONFIG_KERNEL_VERSION:"%"=%)

subproject-$(CONFIG_LINUX)+=$(target)
ifeq ($(CONFIG_LINUX_STD), y)
linux-url:=http://www.kernel.org/pub/linux/kernel/v3.0/linux$(linux-version:%=-%).tar.bz2
endif
linux-linaro-tracking-git:=git://git.linaro.org/kernel/linux-linaro-tracking.git
linux-linaro-url=https://releases.linaro.org/$(linaro-release)/components/kernel/linux-linaro/linux-linaro$($(target)-version:%=-%).tar.bz2

ifneq ($(CONFIG_LINUX_CUSTOM_URL), "")
linux-url:=$(filter-out %.git, $(CONFIG_LINUX_CUSTOM_URL:"%"=%)) $(filter-out git:%, $(CONFIG_LINUX_CUSTOM_URL:"%"=%))
linux-git:=$(filter %.git, $(CONFIG_LINUX_CUSTOM_URL:"%"=%)) $(filter git:%, $(CONFIG_LINUX_CUSTOM_URL:"%"=%))
endif

$(target)-defconfig:=$(CONFIG_KERNEL_DEFCONFIG:"%"=%)
$(target)-makeflags:=$(makeflags) INSTALL_PATH=$(bootdir) INSTALL_MOD_PATH=$(objtree) INSTALL_HDR_PATH=$(objtree)/usr/
ifneq (,$(findstring y,$(CONFIG_U_IMAGE)))
	$(target)-build-target:= uImage modules modules_install headers_install
	$(target)-install:= $(MAKE) $(makeflags) INSTALL_PATH=$(bootdir) INSTALLKERNEL:=noinstallkernel uinstall
else
	$(target)-build-target:= modules $(CONFIG_KERNEL_IMAGE:"%"=%) modules_install headers_install
	$(target)-install:= $(MAKE) $(makeflags) INSTALL_PATH=$(bootdir) INSTALLKERNEL:=noinstallkernel install
endif
