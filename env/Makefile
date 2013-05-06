subproject-$(CONFIG_BUSYBOX)+=busybox
busybox-git:=git://git.busybox.net/busybox.git
busybox-config:=$(MAKE) -C $(src)/busybox ../../config/busybox_defconfig
busybox-build:=$(MAKE) -C $(src)/busybox
busybox-install:=$(MAKE) -C $(src)/busybox CONFIG_PREFIX=$(objtree) install

subdir-$(CONFIG_GNU)+=gnu
