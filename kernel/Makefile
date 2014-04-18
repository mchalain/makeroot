CROSS_COMPILE := $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH := $(CONFIG_ARCH:"%"=%)
export CROSS_COMPILE ARCH

uImage:=arch/$(ARCH)/boot/uImage 

makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

target=$(CONFIG_KERNEL:"%"=%)
subproject-y+=$(target)
$(target)-version:=$(CONFIG_KERNEL_VERSION:"%"=%)

ifeq ($(CONFIG_LINUX_STD), y)
linux-url:=http://www.kernel.org/pub/linux/kernel/v3.0/linux$(linux-version:%=-%).tar.bz2
endif
ifeq ($(CONFIG_LINUX_LINARO), y)
linux-linaro-git:=git://git.linaro.org/kernel/linux-linaro-tracking.git
linux-linaro-url:=http://releases.linaro.org/$(CONFIG_LINUX_LINARO_RELEASE)/components/kernel/$(CONFIG_LINUX_LINARO_DIR)/linux-linaro$(linux-linaro-version:%=-%).tar.bz2
endif
ifneq ($(CONFIG_KERNEL_CUSTOM_URL),"")
$(target:%=%-url):=$(sort $(filter-out %.git, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)) $(filter-out git:%, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)))
$(target:%=%-git):=$(sort $(filter %.git, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)) $(filter git:%, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)))
$(target:%=%-version):=$(if $(filter %.git, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)) $(filter git:%, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)),git,$($(target:%=%-version)))
endif

$(target:%=%-dependances):=$(bootfs)

#sed -e "/unwanted /d" -i scripts/Makefile.headersinst
$(target:%=%-defconfig):=$(CONFIG_KERNEL_DEFCONFIG:"%"=%)
$(target:%=%-makeflags):=$(makeflags) INSTALL_PATH=$(bootfs) INSTALL_MOD_PATH=$(rootfs) INSTALL_HDR_PATH=$(sysroot)/usr/ INSTALLKERNEL:=noinstallkernel
ifneq (,$(findstring y,$(CONFIG_U_IMAGE)))
	$(target:%=%-targets):= uImage modules modules_install headers_install uinstall
	$(target:%=%-install):= find $(rootfs)/lib/modules/ -name build -delete && find $(rootfs)/lib/modules/ -lname source -delete
else
	$(target:%=%-targets):= modules $(CONFIG_KERNEL_IMAGE:"%"=%) modules_install headers_install install
	$(target:%=%-install):= find $(rootfs)/lib/modules/ -lname build -delete && find $(rootfs)/lib/modules/ -lname source -delete
endif

KDIR:=$(srctree)/$(src)/$(target)$($(target)-version:%=-%)
export KDIR
#subdir-y+=$(src)/drivers/video

