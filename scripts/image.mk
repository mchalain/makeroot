include scripts/ubifs.mk
DD=dd

sizeKb:=1000
blocksize=512

define cmd_mkfs-msdos
	$(Q)/sbin/mkfs.msdos -F 32 -n $* -S $(blocksize) $($*-device)
	$(call multicmd,fill-loop)
endef

define cmd_mkfs-vfat
	$(Q)/sbin/mkfs.vfat -n $* -S $(blocksize) $($*-device)
	$(call multicmd,fill-loop)
endef

define cmd_mkfs-ext4
	$(Q)/sbin/mkfs.ext4 -F -L $* -q $($*-device)
	$(call multicmd,fill-loop)
endef

define cmd_mkfs-cramfs
	$(Q)/sbin/mkfs.cramfs -b $(mtd-pagesize) -n $* $($*-data)/ $@
endef

/dev/%:PHONY+=/dev/%
.PHONY:$(PHONY)

quiet_cmd_mkfs = MKFS $*
define cmd_mkfs
	$(if $(findstring vfat,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-vfat))
	$(if $(findstring msdos,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-msdos))
	$(if $(findstring ext4,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-ext4))
	$(if $(findstring ubifs,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-ubifs))
	$(if $(findstring jffs,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-jffs))
	$(if $(findstring cramfs,$($*-fstype)),
		$(eval mkfs-cmd=cmd_mkfs-cramfs))
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
	$(if $(wildcard $(2)),,$(Q)mkdir $(2))
	$(Q)mount $(2)
endef
define mount-dev
	$(Q)sudo mount $(1) $(2)
endef
define umount
	$(Q)sync
	$(Q)sudo umount -f $(1)
endef
define cmd_fill-loop
	$(call $(cmd_mount),$($*-device),/tmp/image/)
	$(Q)$(INSTALL) -DrpP $($*-data)/ /tmp/image/
	$(call umount,/tmp/image/)
endef

/dev/%:cmd_mount:=mount

.PHONY:display-devices
display-devices:
	@echo For $*
	$(eval devices:=$(wildcard /dev/sd[a,b,c,d,e,f]))
	@$(foreach device,$(devices),echo '	'$(device): $(wildcard $(device)*);)

%.request:cmd_mount:=mount-dev
%.request:display-devices
	$(eval cmd_mount=mount-dev)
	$(eval $*-device=$(shell read -p 'select the device file descriptor for $* : ' DEVICE; echo $$DEVICE))

%.disk:cmd_mount:=mount-loop
%.disk:
	$(call multicmd,mkemptyfile)

%.mmc:cmd_mount:=mount-dev
%.mmc:
	$(eval cmd_mount=mount-dev)
	$(if $(wildcard $(flash_device)),,echo "$(flash_device) not found" && exit 1)
	$(if $(wildcard $(flash_device)1),,echo "$(flash_device)1 not found" && exit 1)
	$(if $(wildcard $(flash_device)2),,echo "$(flash_device)2 not found" && exit 1)
	$(eval boot-device:=$(flash_device)1)
	$(eval root-device:=$(flash_device)2)
	$(eval home-device:=$(flash_device)3)

.SECONDEXPANSION:
$(objtree)/%.fs: $$($$*-device)
	$(call multicmd,mkfs)

$(sort $(image-target)):$(objtree)/%.img:$(objtree)/%.fs

$(objtree)/device.img:
	
