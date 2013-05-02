WLD:=/usr

wayland-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WAYLAND)+=wayland
wayland-git="git://anongit.freedesktop.org/wayland/wayland.git"
wayland-url="http://wayland.freedesktop.org/releases/wayland-$(wayland-version).tar.xz"
wayland-config=$(MAKE) -C$(obj)/wayland-$(wayland-version) clean; ./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) --includedir=/usr/include --host=$(CONFIG_CROSS_COMPILE:"%-"=%) --disable-scanner
wayland-makeflags=

hostprogs-$(CONFIG_WAYLAND)+=wayland-scanner
wayland-scanner-url=$(wayland-url)
wayland-scanner-objs=wayland-$(wayland-version)/src/scanner.o wayland-$(wayland-version)/src/wayland-util.o -lexpat

subproject-$(CONFIG_DRM)+=libdrm
libdrm-url="git://anongit.freedesktop.org/git/mesa/drm.git"
libdrm-config=./autogen.sh CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) --includedir=/usr/include --host=$(CONFIG_CROSS_COMPILE:"%-"=%) 

subproject-$(CONFIG_DRM)+=mesa
mesa-url="git://anongit.freedesktop.org/mesa/mesa.git"
mesa-config=./autogen.sh CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=$(WLD) --includedir=/usr/include $(CONFIG_MESA_OPTIONS:"%"=%) --host=$(CONFIG_CROSS_COMPILE:"%-"=%) 

xkbcommon-version=0.3.0
subproject-$(CONFIG_LIBXKBCOMMON)+=xkbcommon
xkbcommon-url="http://cgit.freedesktop.org/xorg/lib/libxkbcommon/snapshot/xkbcommon-$(libxkbcommon-version).tar.gz"
libxkbcommon-git="git://github.com/xkbcommon/libxkbcommon.git"
xkbcommon-config=./autogen.sh --prefix=$(WLD) --includedir=/usr/include --with-xkb-config-root=$(WLD)/share/xkb --host=$(CONFIG_CROSS_COMPILE:"%-"=%) 

weston-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WESTON)+=weston
weston-url="http://wayland.freedesktop.org/releases/weston-$(weston-version).tar.xz"
weston-git="git://anongit.freedesktop.org/wayland/weston.git"
weston-config=./configure --prefix=$(WLD) --includedir=/usr/include $(CONFIG_WESTON_OPTIONS:"%"=%) --host=$(CONFIG_CROSS_COMPILE:"%-"=%) 

