udev-version=172
subproject-$(CONFIG_UDEV_DEAMON)+=udev
udev-url="https://launchpad.net/udev/main/$(udev-version)/+download/udev$(udev-version:%=-%).tar.bz2"
udev-config=./configure --disable-hwdb --disable-udev_acl --disable-gudev --disable-introspection --disable-keymap --disable-floppy --disable-edd --disable-rule_generator --host=$(CROSS_COMPILE:%-=%) --sysconfdir=/$(CONFIGDIR) --prefix=/ --with-sysroot=/home/mch/Privée/makeroot/out/target/snowball

mtdev-version=1.1.3
subproject-$(CONFIG_MTDEV_DEAMON)+=mtdev
mtdev-url=http://bitmath.org/code/mtdev/mtdev-1.1.3.tar.bz2
