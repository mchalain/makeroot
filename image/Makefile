
#subdir-$(CONFIG_IMAGE_MMC)=image/mmc
#subdir-$(CONFIG_IMAGE_QEMU)=image/mmc

targets-$(CONFIG_UBIFS)+=$(imagename).ubi

root.img: $(rootfs)

mtd-pagesize:=$(CONFIG_MTD_PAGESIZE)
mtd-subpagesize:=$(CONFIG_MTD_SUBPAGESIZE)
mtd-pebsize:=$(CONFIG_MTD_PEBSIZE)

image-$(CONFIG_ROOT_DISK)+=root
root-size:=$(CONFIG_ROOT_SIZE)
root-fstype:=$(CONFIG_ROOT_FS:"%"=%)
root-data:=$(rootfs)
root-device:=root.$(CONFIG_ROOT_DEVICE:"%"=%)

image-$(CONFIG_BOOT_DISK)+=boot
boot-size:=$(CONFIG_BOOT_SIZE)
boot-fstype:=$(CONFIG_BOOT_FS:"%"=%)
boot-data:=$(bootfs)
boot-device:=boot.$(CONFIG_BOOT_DEVICE:"%"=%)

image-$(CONFIG_HOME_DISK)+=home
home-size:=$(CONFIG_HOME_SIZE)
home-fstype:=$(CONFIG_HOME_FS:"%"=%)
home-data:=$(homefs)
home-device:=home.$(CONFIG_HOME_DEVICE:"%"=%)

ifeq ($(CONFIG_IMAGE_MMC),y)
include image/mmc/Makefile
endif

#	qflasher -w -m rx51 -x $QBOOTDIR/xloader-qemu.bin -s $QBOOTDIR/secondary-qemu.bin -k $KERNEL -r /tmp/nemo.ubi.img -o $QEMUDATADIR/$IMAGE -p k=3072 -p i=1024 -p r=257278 -v

