WLD:=/usr

wayland-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WAYLAND)+=wayland
wayland-git="git://anongit.freedesktop.org/wayland/wayland.git"
wayland-url="http://wayland.freedesktop.org/releases/wayland-$(wayland-version).tar.xz"
wayland-mkconfig=$(src)/config/wayland.mk
#wayland-config=$(MAKE) clean; ./configure CC="$(CONFIG_CROSS_COMPILE:"%"=%)-gcc" --prefix=$(WLD) --includedir=/usr/include --host=$(CONFIG_CROSS_COMPILE:"%"=%) --disable-scanner --disable-documentation
wayland-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

hostprogs-$(CONFIG_WAYLAND)+=wayland-scanner
wayland-scanner-url=$(wayland-url)
wayland-scanner-objs=wayland-$(wayland-version)/src/scanner.o wayland-$(wayland-version)/src/wayland-util.o -lexpat
wayland-scanner-install=wayland-scanner

xkbcommon-version=0.3.0
subproject-$(CONFIG_LIBXKBCOMMON)+=xkbcommon
xkbcommon-url="http://cgit.freedesktop.org/xorg/lib/libxkbcommon/snapshot/xkbcommon-$(xkbcommon-version).tar.gz"
libxkbcommon-git="git://github.com/xkbcommon/libxkbcommon.git"
xkbcommon-mkconfig=$(src)/config/wayland.mk
xkbcommon-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
#xkbcommon-config= 

weston-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WESTON)+=weston
weston-url="http://wayland.freedesktop.org/releases/weston-$(weston-version).tar.xz"
weston-git="git://anongit.freedesktop.org/wayland/weston.git"
weston-config=./configure --prefix=$(WLD) --includedir=/usr/include $(CONFIG_WESTON_OPTIONS:"%"=%) --host=$(CONFIG_CROSS_COMPILE:"%"=%) 

DirectFB-version=1.6.3
subproject-$(CONFIG_DIRECTFB)+=DirectFB
DirectFB-git=git://git.directfb.org/git/directfb/core/DirectFB.git
DirectFB-url=http://directfb.org/downloads/Core/DirectFB-1.6/DirectFB-$(DirectFB-version).tar.gz
DirectFB-mkconfig=$(src)/config/DirectFB.mk
