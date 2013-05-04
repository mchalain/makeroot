
u-boot-dir=u-boot

subproject-$(CONFIG_U_BOOT_UX500)+=u-boot-ux500
u-boot-ux500-url:=git://igloocommunity.org/git/boot/u-boot-ux500.git
u-boot-ux500-config:=$(MAKE) -C $(src)/$(u-boot-dir) snowball_config

subproject-$(CONFIG_U_BOOT)+=u-boot
u-boot-url:=git://www.denx.de/git/u-boot.git
u-boot-config:=$(MAKE) -C $(src)/$(u-boot-dir) snowball_config

#hostprogs-$(CONFIG_U_IMAGE)+=mkimage
mkimage-objs=$(u-boot-dir)/tools/aisimage.o \
	$(u-boot-dir)/lib/crc32.o \
	$(u-boot-dir)/tools/default_image.o \
	$(u-boot-dir)/tools/fit_image.o \
	$(u-boot-dir)/common/image.o \
	$(u-boot-dir)/tools/imximage.o \
	$(u-boot-dir)/tools/kwbimage.o \
	$(u-boot-dir)/tools/pblimage.o \
	$(u-boot-dir)/lib/md5.o \
	$(u-boot-dir)/tools/mkimage.o \
	$(u-boot-dir)/tools/os_support.o \
	$(u-boot-dir)/tools/omapimage.o \
	$(u-boot-dir)/lib/sha1.o \
	$(u-boot-dir)/tools/ublimage.o \
	libfdt.so

libfdt-objs=$(u-boot-dir)/lib/libfdt/fdt.o \
	$(u-boot-dir)/lib/libfdt/fdt_ro.o \
	$(u-boot-dir)/lib/libfdt/fdt_rw.o \
	$(u-boot-dir)/lib/libfdt/fdt_strerror.o \
	$(u-boot-dir)/lib/libfdt/fdt_wip.o

mkimage-cflags+=-I$(src)/$(u-boot-dir)/include/
