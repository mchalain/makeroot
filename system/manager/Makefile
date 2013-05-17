udev-version=172
subproject-$(CONFIG_UDEV_DEAMON)=udev
udev-url="https://launchpad.net/udev/main/$(udev-version)/+download/udev$(udev-version:%=-%).tar.bz2"
udev-config=./configure --disable-hwdb --disable-udev_acl --disable-gudev --disable-introspection --disable-keymap --disable-floppy --disable-edd --disable-rule_generator --host=$(CROSS_COMPILE:%-=%) --sysconfdir=/etc --prefix=/usr --with-sysroot=/home/mch/Privée/makeroot/out/target/snowball
