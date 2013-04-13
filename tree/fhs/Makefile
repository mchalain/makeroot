root:=

install-$(CONFIG_FHS_LINUX)+=etc/fstab home root opt var 
install-$(CONFIG_TREE_PROC)+=proc 
install-$(CONFIG_TREE_SYS)+=sys 
install-$(CONFIG_TREE_DEV)+=dev 
install-$(CONFIG_FSTAB_DEVPTS)+=dev/pts
install-$(CONFIG_FSTAB_DEVSHM)+=dev/shm
install-$(CONFIG_TREE_BOOT)+=boot
install-$(CONFIG_TREE_TMP)+=tmp
install-$(CONFIG_TREE_MEDIA)+=media/floppy media/cdrom media/usb
install-$(CONFIG_TREE_MNT)+=mnt/floppy mnt/cdrom mnt/usb
install-$(CONFIG_TREE_VAR)+=var/log var/mail var/spool var/opt var/cache var/lib/misc var/lib/locate var/run/lock
install-$(CONFIG_TREE_LOCAL)+=local/bin local/lib
install-$(CONFIG_MTAB_SYMLINK)+=etc/mtab tmp/mtab

etc: copy=tree/fhs/etc/
sys: dir=y
proc: dir=y
dev: dir=y
dev/pts: dir=y
dev/shm: dir=y
boot: dir=y
tmp: dir=y
home root opt: dir=y
var/log var/mail var/spool var/opt var/cache var/lib/misc var/lib/locate var/run/lock: dir=y
media/floppy media/cdrom media/usb: dir=y
mnt/floppy mnt/cdrom mnt/usb: dir=y
local/bin local/lib: dir=y
etc/mtab: link=tmp/mtab
tmp/mtab: touch=y

etc/fstab: copy=tree/fhs/etc/fstab
etc/fstab: tree/fhs/etc/fstab

tree/fhs/etc/fstab: FORCE
	@echo '/dev/root	/	auto	defaults	0	0' > $@
	@$(if $(CONFIG_FSTAB_DEV), echo 'devtmpfs	/dev	devtmpfs	mode=0755$(comma)rw	0	0' >> $@ )
	@$(if $(CONFIG_FSTAB_DEVPTS), echo 'devpts		/dev/pts	devpts	gid=5$(comma)mode=620	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_DEVSHM), echo 'tmpfs		/dev/shm	tmpfs	defaults$(comma)size=$(CONFIG_FSTAB_DEVSHM_SIZE)	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_PROC), echo 'proc		/proc	proc	nodev$(comma)noexec$(comma)nosuid	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_SYS), echo 'sysfs		/sys	sysfs	nosuid$(comma)noexec$(comma)nodev	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_TMP), echo 'tmpfs		/tmp	tmpfs	defaults	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_BOOTVFAT), echo 'LABEL=boot	/boot	vfat	rw$(comma)quiet$(comma)showexec$(comma)iocharset=utf8	0	0' >> $@)

FORCE: ;
