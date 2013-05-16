subproject-$(CONFIG_DRM)+=libdrm
libdrm-git="git://anongit.freedesktop.org/git/mesa/drm.git"
libdrm-mkconfig=$(srctree)/graphics/egl/config/mesa.mk

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
weston-mkconfig=$(src)/config/wayland.mk

DirectFB-version=1.6.3
subproject-$(CONFIG_DIRECTFB)+=DirectFB
DirectFB-git=git://git.directfb.org/git/directfb/core/DirectFB.git
DirectFB-url=http://directfb.org/downloads/Core/DirectFB-1.6/DirectFB-$(DirectFB-version).tar.gz
DirectFB-mkconfig=$(src)/config/DirectFB.mk
