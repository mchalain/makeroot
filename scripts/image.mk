DD=dd

sizeKb:=1000
blocksize=512

define cmd_mkfs-msdos
	$(call multicmd,mkemptyfile)
	$(Q)mkfs.msdos -F 32 -n $(*) -S $(blocksize) $(objtree)/$@
	$(call multicmd,fill-loop)
endef

define cmd_mkfs-vfat
	$(call multicmd,mkemptyfile)
	$(Q)mkfs.vfat -n $(*) -S $(blocksize) $(objtree)/$@
	$(call multicmd,fill-loop)
endef

define cmd_mkfs-ext4
	$(call multicmd,mkemptyfile)
	$(Q)/sbin/mkfs.ext4 -F -L $(*) -q $(objtree)/$*.disk
	$(call multicmd,fill-loop)
endef

quiet_cmd_mkfs = MKFS $*
define cmd_mkfs
	$(if $(findstring vfat,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-vfat))
	$(if $(findstring ext4,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-ext4))
	$(if $(findstring ubifs,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-ubifs))
	$(if $(findstring jffs,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-jffs))
	$(call $(mkfs-cmd))
endef

define cmd_mkemptyfile
	$(eval sizeblk=$(shell echo $($*-size)'*'$(sizeKb)'*'$(sizeKb)/$(blocksize) | bc))
	$(Q)$(DD) count=$(sizeblk) bs=$(blocksize) if=/dev/zero of=$(objtree)/$*.disk
endef

tmpdir:
	mkdir -p tmpdir

define mount_loop
	$(Q)rm -rf /tmp/image.iso
	$(Q)ln -s $(1) /tmp/image.iso
	$(if $(wildcard /tmp/image),,$(Q)mkdir /tmp/image)
	$(Q)mount /tmp/image
endef
define umount
	$(Q)sudo umount -f /tmp/image
endef
define cmd_fill-loop
	$(call mount_loop,$(objtree)/$*.disk)
	$(call copydir,$($*-data)/,/tmp/image/)
	$(call umount)
	$(Q)mv $(objtree)/$*.disk $@
endef

$(objtree)/%.fs:
	$(call multicmd,mkfs)

.SECONDEXPANSION:
$(sort $(image-target)):$(objtree)/%.img:$(objtree)/%.fs
