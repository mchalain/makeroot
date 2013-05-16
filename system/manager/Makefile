udev-version=172
subproject-$(CONFIG_UDEV_DEAMON)=udev
udev-url="https://launchpad.net/udev/main/$(udev-version)/+download/udev$(udev-version:%=-%).tar.bz2"
udev-config=./configure CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --disable-hwdb --disable-udev_acl --disable-gudev --disable-introspection --disable-keymap --disable-floppy --disable-edd --host=$(CROSS_COMPILE:%-=%) --sysconfdir=/etc --prefix=/usr
