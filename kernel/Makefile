CROSS_COMPILE := $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH := $(CONFIG_ARCH:"%"=%)
export CROSS_COMPILE ARCH

bootdir:=$(objtree)/boot
uImage:=arch/$(ARCH)/boot/uImage 

makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

target=$(CONFIG_KERNEL:"%"=%)
subproject-$(CONFIG_LINUX)+=$(target)
$(target)-version:=$(CONFIG_KERNEL_VERSION:"%"=%)

linux-linaro-git:=git://git.linaro.org/kernel/linux-linaro-tracking.git
linux-linaro-url:=http://releases.linaro.org/$(CONFIG_LINUX_LINARO_RELEASE)/components/kernel/$(CONFIG_LINUX_LINARO_DIR)/linux-linaro$(linux-linaro-version:%=-%).tar.bz2
igloo-kernel-git:=git://igloocommunity.org/git/kernel/igloo-kernel.git

ifeq ($(CONFIG_LINUX_STD), y)
linux-url:=http://www.kernel.org/pub/linux/kernel/v3.0/linux$(linux-version:%=-%).tar.bz2
endif
ifneq ($(CONFIG_LINUX_CUSTOM_URL), "")
linux-url:=$(filter-out %.git, $(CONFIG_LINUX_CUSTOM_URL:"%"=%)) $(filter-out git:%, $(CONFIG_LINUX_CUSTOM_URL:"%"=%))
linux-git:=$(filter %.git, $(CONFIG_LINUX_CUSTOM_URL:"%"=%)) $(filter git:%, $(CONFIG_LINUX_CUSTOM_URL:"%"=%))
endif

#sed -e "/unwanted /d" -i scripts/Makefile.headersinst
$(target)-defconfig:=$(CONFIG_KERNEL_DEFCONFIG:"%"=%)
$(target)-makeflags:=$(makeflags) INSTALL_PATH=$(bootdir) INSTALL_MOD_PATH=$(objtree) INSTALL_HDR_PATH=$(objtree)/usr/
ifneq (,$(findstring y,$(CONFIG_U_IMAGE)))
	$(target)-build-target:= uImage modules modules_install headers_install
	$(target)-install:= $(MAKE) $($(target)-makeflags) INSTALL_PATH=$(bootdir) INSTALLKERNEL:=noinstallkernel uinstall
else
	$(target)-build-target:= modules $(CONFIG_KERNEL_IMAGE:"%"=%) modules_install headers_install
	$(target)-install:= $(MAKE) $($(target)-makeflags) INSTALL_PATH=$(bootdir) INSTALLKERNEL:=noinstallkernel install
endif

KDIR:=$(srctree)/$(src)/$(target)$($(target)-version:%=-%)
export KDIR
#subdir-y+=$(src)/drivers/video

