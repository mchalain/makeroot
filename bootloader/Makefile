
u-boot-dir=u-boot

u-boot-version=$(CONFIG_U_BOOT_VERSION:"%"=%)
subproject-$(CONFIG_U_BOOT)+=u-boot
ifeq ($(findstring ux500,$(u-boot-version)),ux500)
u-boot-git:=https://github.com/igloocommunity/u-boot-ux500.git
u-boot-version=git
else
u-boot-version=git
u-boot-git:=git://www.denx.de/git/u-boot.git
endif
u-boot:=$(CONFIG_U_BOOT_TARGET:"%"=%)_config
u-boot-config:=make $(CONFIG_U_BOOT_TARGET:"%"=%)_config
u-boot-hostbin:=dumpimage img2brec.sh img2srec jtagconsole mkenvimage mkimage netconsole proftool reformat.py
u-boot-hostbin:=$(addprefix tools/,$(u-boot-hostbin))
u-boot-script:=boot.scr
u-boot-install:= \
	cp $(u-boot-hostbin) $(hostbin)

install-$(CONFIG_U_BOOT_SCRIPT)+=boot/boot.scr
boot/boot.scr:generate=/tmp/boot.scr
boot/boot.scr:/tmp/boot.scr
/tmp/boot.scr:/tmp/boot.script
	$(Q)$(hostbin)/mkimage -A $(CONFIG_ARCH:"%"=%) -T script -C none -n "$(MAKEROOT_NAME) boot script" -d $< $@

/tmp/boot.script: bootfstype:=$(if $(findstring msdos,$(CONFIG_BOOT_FS:"%"=%)) $(findstring vfat,$(CONFIG_BOOT_FS:"%"=%)),fat,$(CONFIG_BOOT_FS:"%"=%))
/tmp/boot.script:
	@echo "setenv common-args "'"'console=ttyAMA2,115200n8 root=/dev/$(strip $(CONFIG_MMC_DEVICE:"mmcblk%"=mmcblk%p)$(CONFIG_ROOT_DISK_PARTNUM)) rootwait'"' > $@
	@echo "setenv $(CONFIG_U_BOOT_TARGET:"%"=%)-args "'"'$(CONFIG_KERNEL_CMDLINE_1:"%"=%) $(CONFIG_KERNEL_CMDLINE_2:"%"=%) $(CONFIG_KERNEL_CMDLINE_3:"%"=%)'"' >> $@
	@echo 'setenv bootargs $${common-args} $${'$(CONFIG_U_BOOT_TARGET:"%"=%)-args'}' >> $@
	@echo "loadaddr=$(CONFIG_KERNEL_RAMADDR:"%"=%)" >> $@
	@echo "kernelname=/$(CONFIG_KERNEL_IMAGE:"%"=%)" >> $@
	@echo "$(bootfstype) load mmc $(CONFIG_MMC_DEVICE:"mmcblk%"=%):$(CONFIG_BOOT_DISK_PARTNUM) "'$${loadaddr} $${kernelname}' >> $@
	@echo 'bootm $${loadaddr}' >> $@
