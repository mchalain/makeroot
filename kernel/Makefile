CROSS_COMPILE := $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH := $(CONFIG_ARCH:"%"=%)
export CROSS_COMPILE ARCH

bootdir:=$(objtree)/boot
uImage:=arch/$(ARCH)/boot/uImage 

makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)


ifeq ($(CONFIG_LINUX_LINARO_TRACKING), y)
version:=-linaro-tracking
CONFIG_KERNEL_VERSION=linaro-tracking
else
version:=-$(CONFIG_KERNEL_VERSION:"%"=%)
endif

kprj=linux$(version)
subproject-$(CONFIG_LINUX)+=$(kprj)
ifeq ($(CONFIG_LINUX_STD), y)
$(kprj)-url:=http://www.kernel.org/pub/linux/kernel/v3.0/$(kprj).tar.bz2
endif
linux-linaro-tracking-git:=git://git.linaro.org/kernel/linux-linaro-tracking.git
ifneq ($(CONFIG_LINUX_CUSTOM_URL), "")
$(kprj)-url:=$(filter-out %.git, $(CONFIG_LINUX_CUSTOM_URL:"%"=%)) $(filter-out git:%, $(CONFIG_LINUX_CUSTOM_URL:"%"=%))
$(kprj)-git:=$(filter %.git, $(CONFIG_LINUX_CUSTOM_URL:"%"=%)) $(filter git:%, $(CONFIG_LINUX_CUSTOM_URL:"%"=%))
endif

$(kprj)-defconfig:=$(CONFIG_KERNEL_DEFCONFIG:"%"=%)
$(kprj)-makeflags:=$(makeflags)
$(kprj)-install:=$(MAKE) $(makeflags) -C $(src)/$(kprj) INSTALL_PATH=$(bootdir) install
$(kprj)-install+=; echo INSTALL MODULES; $(MAKE) $(makeflags) -C $(src)/$(kprj) INSTALL_MOD_PATH=$(objtree)  modules_install
$(kprj)-install+=; echo INSTALL HEADERS; $(MAKE) $(makeflags) -C $(src)/$(kprj) INSTALL_HDR_PATH=$(objtree)/usr/ headers_install
ifneq (,$(findstring y,$(CONFIG_U_IMAGE)))
	$(kprj)-build-target:= uImage modules
	$(kprj)-install+= ; echo COPY $(src)/$(kprj)/$(uImage); cp $(src)/$(kprj)/$(uImage) $(bootdir)
else
	$(kprj)-build-target:= modules $(CONFIG_KERNEL_IMAGE:"%"=%) 
endif
