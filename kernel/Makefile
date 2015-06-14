uImage:=arch/$(ARCH)/boot/uImage 

# for the Kernel, CFLAGS is not used
# for the Kernel, standard LDFLAGS set gcc options and not ld options
makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
	CFLAGS="" LDFLAGS=""

kernel=$(CONFIG_KERNEL:"%"=%)
subproject-y+=$(kernel)
#default kernel-version
$(kernel)-version:=$(CONFIG_KERNEL_VERSION:"%"=%)

ifeq ($(CONFIG_LINUX_STD), y)
linux-url:=http://www.kernel.org/pub/linux/kernel/v3.0/linux$(linux-version:%=-%).tar.bz2
else
ifeq ($(CONFIG_LINUX_LINARO), y)
linaro-version:=$(CONFIG_LINARO_VERSION:"%"=%)
ifneq ($(CONFIG_KERNEL_VERSION:"%"=%),git)
linux-version:=linaro-stable-$(CONFIG_KERNEL_VERSION:"%"=%)
endif
linaro-lsk:=$(if $(CONFIG_LINARO_LSK),stable-lsk)
linux-git:=git://git.linaro.org/kernel/linux-linaro-stable.git
linux-url:=http://releases.linaro.org/$(linaro-version)/components/kernel/linux-linaro$(linaro-lsk:%=-%)/linux-$(linux-version).tar.bz2
endif
endif

KDIR:=$(src)/$(kernel)$($(kernel)-version:%=-%)
export KDIR

ifneq ($(CONFIG_KERNEL_CUSTOM_URL),"")
$(kernel:%=%-url):=$(sort $(filter-out %.git, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)) $(filter-out git:%, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)))
$(kernel:%=%-git):=$(if $(sort $(filter %.git, $(CONFIG_KERNEL_CUSTOM_URL)) $(filter git:%, $(CONFIG_KERNEL_CUSTOM_URL))), $(CONFIG_KERNEL_CUSTOM_URL))
$(kernel:%=%-version):=$(if $(filter %.git, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)) $(filter git:%, $(CONFIG_KERNEL_CUSTOM_URL:"%"=%)),git,$($(kernel:%=%-version)))
endif

$(kernel:%=%-dependances):=$(bootfs)

#sed -e "/unwanted /d" -i scripts/Makefile.headersinst
$(kernel:%=%-defconfig):=$(CONFIG_KERNEL_DEFCONFIG:"%"=%)
$(kernel:%=%-destdir):=$(join $(packagesdir)/,$(if $(filter-out git hg cvs,$($(kernel)-version)),$(kernel)-$($(kernel)-version),$(kernel)))
$(kernel:%=%-makeflags):=$(makeflags) INSTALL_PATH=$(bootfs) INSTALL_MOD_PATH=$($(kernel:%=%-destdir)) INSTALL_HDR_PATH=$($(kernel:%=%-destdir))/usr/ INSTALLKERNEL:=noinstallkernel LOADADDR=$(CONFIG_KERNEL_RAMADDR:"%"=%)
ifneq (,$(findstring y,$(CONFIG_U_IMAGE)))
	$(kernel:%=%-targets):= uImage modules modules_install headers_install
	$(kernel:%=%-install):= find $($(kernel:%=%-destdir))/lib/modules/ -name build -delete && find $($(kernel:%=%-destdir))/lib/modules/ -name source -delete && $(INSTALL) -DrpP arch/arm/boot/uImage $($(kernel:%=%-destdir))/boot/ && $(INSTALL) -DrpP arch/arm/boot/uImage $(bootfs)
else
	$(kernel:%=%-targets):= $(CONFIG_KERNEL_IMAGE:"%"=%) modules modules_install headers_install install
	$(kernel:%=%-install):= find $($(kernel:%=%-destdir))/lib/modules/ -name build -delete && find $($(kernel:%=%-destdir))/lib/modules/ -name source -delete
endif

rtems-version:=4.10.2
rtems-url:=http://git.rtems.org/rtems/snapshot/rtems-$(rtems-version).tar.bz2
rtems-git:=git://git.rtems.org/rtems.git

kernel-headers-version:=git
subproject-$(CONFIG_KERNEL_HEADERS_MODIFIED)+=kernel-headers
kernel-headers-git:=git://github.com/sabotage-linux/kernel-headers
kernel-headers-config:=echo done
kernel-headers-build:=echo done
kernel-headers-makeflags:=ARCH=$(ARCH) prefix=/usr

#subdir-y+=$(src)/drivers/video

