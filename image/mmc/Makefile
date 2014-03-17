targets-$(CONFIG_IMAGE_MMC)+=image/mmc
targets-$(CONFIG_IMAGE_QEMU)+=$(CONFIG_MMC_ROOT_PATH:"%"=%)

device=$(CONFIG_MMC_BLOCKDEVICE:"%"=%)
mmcboot=$(CONFIG_MMC_BOOT_PATH:"%"=%)
mmcroot=$(CONFIG_MMC_ROOT_PATH:"%"=%)
mmcuser=$(CONFIG_MMC_USER_PATH:"%"=%)
p1=$(CONFIG_MMC_BOOT_PARTITION)
p2=$(CONFIG_MMC_ROOT_PARTITION)
p3=$(CONFIG_MMC_USER_PARTITION)
heads=255
sectors=63
sector_size=512
cylinders = $(shell echo $(CONFIG_IMAGE_SIZE)/$(heads)/$(sectors)/$(sector_size) | bc)

$(device):
	@$(if $(findstring y, $(CONFIG_IMAGE_QEMU)), \
		qemu-img create -f raw $@ $(CONFIG_IMAGE_SIZE), \
		echo "insert sd card inside $(device)"; false)

$(device)$(p1) $(device)$(p2): $(device)
	sfdisk  -D -H $(heads) -S $(sectors) -C $(cylinders) $(device) << EOF
	,9,0x0C,*
	,,,-
	;
	;
	EOF

#$(mmcboot): $(device)$(p1)
$(mmcboot): dir=y
$(mmcboot):
	mkdosfs -F 32 -n boot $(device)$(p1)
	$(MKDIR) $(mmcroot)
	mount -t vfat $(device)$(p1) $(mmcboot)

#$(mmcroot): $(device)$(p2)
$(mmcroot):
	mke2fs -L root  $(device)$(p2)
	$(MKDIR) $(mmcroot)
	mount -t ext2 $(device)$(p2) $(mmcroot)

$(mmcboot)/: copy=$(objtree)/boot/*
$(mmcboot)/: $(mmcboot) FORCE
	$(call cmd,install)

$(mmcroot)/: copy=$(objtree)/*
$(mmcroot)/: $(mmcroot) FORCE
	$(call cmd,install)

PHONY+=image/mmc
image/mmc: $(mmcboot)/ $(mmcroot)/
