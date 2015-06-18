root:=

install-$(CONFIG_FHS_LSB)+=bin sbin home opt var proc sys dev tmp etc
bin sbin home root opt var proc sys dev tmp etc: dir=y
install-$(CONFIG_FHS_LSB)+=usr/bin usr/sbin
usr/bin usr/sbin: dir=y
install-$(CONFIG_USR_LOCAL)+=usr/local/bin usr/local/lib usr/local/include
usr/local/bin usr/local/lib usr/local/include: dir=y
install-$(CONFIG_FHS_BOOT)+=boot
boot: dir=y

install-$(CONFIG_MEDIADIRS)+=media/floppy media/cdrom media/usb
install-$(CONFIG_MNTDIRS)+=mnt/floppy mnt/cdrom mnt/usb

#users database files
install-$(CONFIG_FHS_USERS)+=etc/group etc/passwd etc/shadow
etc/group: copy=$(src)/etc/group
etc/passwd: copy=$(src)/etc/passwd
etc/shadow: copy=$(src)/etc/shadow

#network configuration directory
etc/network: dir=y

#filesystem table file
install-$(CONFIG_FSTAB)+=etc/fstab
install-$(CONFIG_FSTAB_DEVPTS)+=dev/pts
install-$(CONFIG_FSTAB_DEVSHM)+=dev/shm
etc/fstab: generate=/tmp/fstab
etc/fstab: /tmp/fstab
/tmp/fstab: FORCE
	@echo '/dev/root	/	auto	defaults	0	0' > $@
	@$(if $(CONFIG_FSTAB_DEV), echo 'devtmpfs	/dev	devtmpfs	mode=0755$(comma)rw	0	0' >> $@ )
	@$(if $(CONFIG_FSTAB_DEVPTS), echo 'devpts		/dev/pts	devpts	gid=5$(comma)mode=620	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_DEVSHM), echo 'tmpfs		/dev/shm	tmpfs	defaults$(comma)size=$(CONFIG_FSTAB_DEVSHM_SIZE)	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_PROC), echo 'proc		/proc	proc	nodev$(comma)noexec$(comma)nosuid	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_SYS), echo 'sysfs		/sys	sysfs	nosuid$(comma)noexec$(comma)nodev	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_TMP), echo 'tmpfs		/tmp	tmpfs	defaults	0	0' >> $@)
	@$(if $(CONFIG_FSTAB_BOOTVFAT), echo 'LABEL=boot	/boot	vfat	rw$(comma)quiet$(comma)showexec	0	0' >> $@)
dev/pts: dir=y
dev/shm: dir=y

install-$(CONFIG_VARSUBDIRS)+=var/log var/mail var/spool var/opt var/cache var/lib/misc var/lib/locate var/run
ifeq ($(CONFIG_TMPFS), y)
var/log: link=../tmp/var/log
var/cache: link=../tmp/var/cache
var/run: link=../tmp/var/run
var/mail var/spool var/opt var/lib/misc var/lib/locate: dir=y
#mount file
install-$(CONFIG_TMPFS)+=etc/mtab
etc/mtab: link=../tmp/mtab
else
var/log var/mail var/spool var/opt var/cache var/lib/misc var/lib/locate var/run/lock: dir=y
endif

media/floppy media/cdrom media/usb: dir=y
mnt/floppy mnt/cdrom mnt/usb: dir=y

install-$(CONFIG_DEV_MDEV)+=etc/init.d/mdev
etc/init.d/mdev: generate=/tmp/mdev
etc/init.d/mdev: /tmp/mdev
/tmp/mdev:
	@echo '#!/bin/sh' > $@
	@echo 'echo /bin/mdev >/proc/sys/kernel/hotplug' >> $@

FORCE: ;
