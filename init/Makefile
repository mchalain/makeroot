
install-$(CONFIG_INITTAB)+=etc/inittab
install-$(CONFIG_SYSTEMV_STARTUP)+=etc/init.d/rcS
install-$(CONFIG_DEV_MDEV)+=etc/init.d/rc.mdev

etc/inittab: copy:=$(CONFIG_INITTAB_FILE:"%"=%)

etc/init.d/rcS: copy:=$(CONFIG_RCS_FILE:"%"=%)
etc/init.d/rcS: chown:=root
etc/init.d/rcS: chmod:=744

etc/init.d/rc.mdev:
	@echo '#!/bin/sh' > $@
	@echo 'echo /bin/mdev >/proc/sys/kernel/hotplug' >> $@