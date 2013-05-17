subproject-$(CONFIG_DRM)+=libdrm
libdrm-git="git://anongit.freedesktop.org/git/mesa/drm.git"
libdrm-mkconfig=graphics/egl/config/mesa.mk

xkbcommon-version=0.3.0
subproject-$(CONFIG_LIBXKBCOMMON)+=xkbcommon
xkbcommon-url="http://cgit.freedesktop.org/xorg/lib/libxkbcommon/snapshot/xkbcommon-$(xkbcommon-version).tar.gz"
libxkbcommon-git="git://github.com/xkbcommon/libxkbcommon.git"
xkbcommon-mkconfig=graphics/system/config/wayland.mk
xkbcommon-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
#xkbcommon-config= 

DirectFB-version=1.6.3
subproject-$(CONFIG_DIRECTFB)+=DirectFB
DirectFB-git=git://git.directfb.org/git/directfb/core/DirectFB.git
DirectFB-url=http://directfb.org/downloads/Core/DirectFB-1.6/DirectFB-$(DirectFB-version).tar.gz
DirectFB-mkconfig=graphics/system/config/DirectFB.mk

cairo-version=1.12.14
subproject-$(CONFIG_CAIRO)+=cairo
cairo-url=http://cairographics.org/releases/cairo-1.12.14.tar.xz
