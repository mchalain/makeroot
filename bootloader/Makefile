
u-boot-dir=u-boot
u-boot-targetname:=$(CONFIG_U_BOOT_TARGET:"%"=%)

u-boot-version=$(CONFIG_U_BOOT_VERSION:"%"=%)
subproject-$(CONFIG_U_BOOT)+=u-boot
ifeq ($(findstring ux500,$(u-boot-version)),ux500)
u-boot-git:=https://github.com/igloocommunity/u-boot-ux500.git
u-boot-version=git
else
u-boot-version=git
u-boot-git:=git://www.denx.de/git/u-boot.git
endif
u-boot:=$(u-boot-targetname)_config
u-boot-config:=make $(u-boot-targetname)_config
u-boot-hostbin:=dumpimage img2brec.sh img2srec jtagconsole mkenvimage mkimage netconsole proftool reformat.py
u-boot-hostbin:=$(addprefix tools/,$(u-boot-hostbin))
u-boot-script:=boot.scr
u-boot-install:= \
	cp $(u-boot-hostbin) $(hostbin)

init:=/sbin/init
mmcdevice:=$(CONFIG_MMC_DEVICE:"%"=%)
rootdevice:=$(strip $(mmcdevice:mmcblk%=mmcblk%p)$(CONFIG_ROOT_DISK_PARTNUM))
bootdevice:=$(strip $(mmcdevice:mmcblk%=mmcblk%p)$(CONFIG_BOOT_DISK_PARTNUM))
cmdline:=$(CONFIG_KERNEL_CMDLINE_1:"%"=%) $(CONFIG_KERNEL_CMDLINE_2:"%"=%) $(CONFIG_KERNEL_CMDLINE_3:"%"=%)
loadaddr:=$(CONFIG_KERNEL_RAMADDR:"%"=%)
kernelname:=$(CONFIG_KERNEL_IMAGE:"%"=%)

/tmp/boot.script: bootfstype:=$(if $(findstring msdos,$(CONFIG_BOOT_FS:"%"=%)) $(findstring vfat,$(CONFIG_BOOT_FS:"%"=%)),fat,$(CONFIG_BOOT_FS:"%"=%))
/tmp/boot.script: $(if $(findstring y,$(force)),FORCE)
	@echo build $@
	@echo "setenv common-args "'"'console=ttyAMA2,115200n8 init=$(init) root=/dev/$(rootdevice) rootwait'"' > $@
	@echo "setenv $(u-boot-targetname)-args "'"'$(cmdline)'"' >> $@
	@echo 'setenv bootargs $${common-args} $${'$(u-boot-targetname)-args'}' >> $@
	@echo "loadaddr=$(loadaddr)" >> $@
	@echo "kernelname=/$(kernelname)" >> $@
	@echo "$(bootfstype) load mmc $(subst p,:,$(bootdevice:mmcblk%=%)) "'$${loadaddr} $${kernelname}' >> $@
	@echo 'bootm $${loadaddr}' >> $@

install-$(CONFIG_U_BOOT_SCRIPT)+=boot/boot.scr
boot/boot.scr:generate=/tmp/boot.scr
boot/boot.scr:/tmp/boot.scr
/tmp/boot.scr:/tmp/boot.script
	$(Q)$(hostbin)/mkimage -A $(ARCH) -T script -C none -n "$(MAKEROOT_NAME) boot script" -d $< $@

