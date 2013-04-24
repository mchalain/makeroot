device=$(CONFIG_MMC_BLOCKDEVICE:"%"=%)
mmcboot=$(CONFIG_MMC_BOOT_PATH:"%"=%)
mmcroot=$(CONFIG_MMC_ROOT_PATH:"%"=%)
mmcuser=$(CONFIG_MMC_USER_PATH:"%"=%)
p1=p$(CONFIG_MMC_BOOT_PARTITION)
p2=p$(CONFIG_MMC_ROOT_PARTITION)
p3=p$(CONFIG_MMC_USER_PARTITION)
cylinders = $(shell echo $(CONFIG_IMAGE_SIZE)/255/63/512 | bc)

$(device):
	@$(if $(findstring y, $(CONFIG_IMAGE_QEMU)), qemu-img create -f raw $@ $(CONFIG_IMAGE_SIZE), echo "change CONFIG_MMC_BLOCKDEVICE")

$(device)$(p1) $(device)$(p2): $(device)
	{ \
	    echo ,9,0x0C,* ; \
	    echo ,,,- \
	} | sfdisk  -D -H 255 -S 63 -C $(cylinders) $(device)

$(mmcboot): $(device)$(p1)
	mkdosfs -F 32 -n boot $(device)$(p1)
	$(MKDIR) $(mmcroot)
	mount -t vfat $(device)$(p1) $(mmcboot)

$(mmcroot): $(device)$(p2)
	mke2fs -L root  $(device)$(p2)
	$(MKDIR) $(mmcroot)
	mount -t ext2 $(device)$(p2) $(mmcroot)

PHONY+=image/mmc
image/mmc: $(mmcboot) $(mmcroot)
	$(CP) $(TARGET_OUT)/boot/* $(mmcboot)
	$(CP) $(TARGET_OUT)/* $(mmcroot)
