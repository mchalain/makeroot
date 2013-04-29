WLD:=/usr/wayland

subproject-$(CONFIG_EXPAT)+=libexpat-2.1.0
libexpat-2.1.0-url="http://sourceforge.net/projects/expat/files/expat/2.1.0/expat-2.1.0.tar.gz"
libexpat-2.1.0-config=./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=/usr --host=$(CONFIG_CROSS_COMPILE:"%-"=%) --with-sysroot=$(objtree)
libexpat-2.1.0-makeflags=

subproject-$(CONFIG_LIBFFI)+=libffi
libffi-url="git://github.com/atgreen/libffi.git"
libffi-config=./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=/usr --host=$(CONFIG_CROSS_COMPILE:"%-"=%)
libffi-makeflags=

wayland-version=1.0.6
hostprogs-$(CONFIG_WAYLAND)+=wayland-scanner
wayland-scanner-objs=wayland-$(wayland-version)/src/scanner.o wayland-$(wayland-version)/src/wayland-util.o -lexpat

subproject-$(CONFIG_WAYLAND)+=wayland
wayland-git="git://anongit.freedesktop.org/wayland/wayland.git"
wayland-url="http://wayland.freedesktop.org/releases/wayland-$(wayland-version).tar.xz"
wayland-config=$(MAKE) -C$(obj)/wayland-$(wayland-version) clean; ./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) --host=$(CONFIG_CROSS_COMPILE:"%-"=%) --disable-scanner
wayland-makeflags=

subproject-$(CONFIG_DRM)+=libdrm
libdrm-url="git://anongit.freedesktop.org/git/mesa/drm.git"
libdrm-config=./autogen.sh CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD)

subproject-$(CONFIG_DRM)+=mesa
mesa-url="git://anongit.freedesktop.org/mesa/mesa.git"
mesa-config=./autogen.sh CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) $(CONFIG_MESA_OPTIONS:"%"=%)

subproject-$(CONFIG_LIBXKBCOMMON)+=libxkbcommon
libxkbcommon-url="git://github.com/xkbcommon/libxkbcommon.git"
libxkbcommon-config=./autogen.sh CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) --with-xkb-config-root=$(WLD)/share/xkb

subproject-$(CONFIG_WESTON)+=weston
weston-url="git://anongit.freedesktop.org/wayland/weston.git"
weston-config=./autogen.sh CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) $(CONFIG_WESTON_OPTIONS:"%"=%)

