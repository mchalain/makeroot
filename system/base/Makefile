busybox-version:=$(CONFIG_BUSYBOX_VERSION)
subproject-$(CONFIG_BUSYBOX)+=busybox
busybox-url:=http://www.busybox.net/downloads/busybox-$(busybox-version).tar.bz2
busybox-git:=git://git.busybox.net/busybox.git
busybox-defconfig:=$(src)/config/busybox_defconfig
busybox-makeflags=CONFIG_PREFIX=$(sprj-destdir)

subdir-$(CONFIG_GNU)+=gnu
