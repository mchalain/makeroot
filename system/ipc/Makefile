WLD:=/usr

wayland-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WAYLAND_LIB)+=wayland
wayland-git="git://anongit.freedesktop.org/wayland/wayland.git"
wayland-url="http://wayland.freedesktop.org/releases/wayland-$(wayland-version).tar.xz"
wayland-mkconfig=$(srctree)/graphics/system/config/wayland.mk
#wayland-config=$(MAKE) clean; ./configure CC="$(CONFIG_CROSS_COMPILE:"%"=%)-gcc" --prefix=$(WLD) --includedir=/usr/include --host=$(CONFIG_CROSS_COMPILE:"%"=%) --disable-scanner --disable-documentation
wayland-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

hostprogs-$(CONFIG_WAYLAND)+=wayland-scanner
wayland-scanner-url=$(wayland-url)
wayland-scanner-objs=wayland-$(wayland-version)/src/scanner.o wayland-$(wayland-version)/src/wayland-util.o -lexpat
wayland-scanner-install=wayland-scanner

linux-fusion-version=9.0.0
subproject-$(CONFIG_LINUX_FUSION)+=linux-fusion
linux-fusion-git=git://git.directfb.org/git/directfb/core/linux-fusion.git
linux-fusion-url=http://directfb.org/downloads/Core/linux-fusion/linux-fusion-$(linux-fusion-version).tar.gz
linux-fusion-mkconfig=$(src)/config/linux-fusion.mk

