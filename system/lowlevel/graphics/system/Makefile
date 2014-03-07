subproject-$(CONFIG_DRM)+=libdrm
libdrm-git="git://anongit.freedesktop.org/git/mesa/drm.git"
libdrm-mkconfig=$(src)/../egl/config/mesa.mk

subproject-$(CONFIG_BOARD_SNOWBALL)+=hdmiservice
hdmiservice-git=git://igloocommunity.org/git/bsp/hdmiservice.git

subproject-$(CONFIG_BOARD_SNOWBALL)+=b2r2lib
b2r2lib-git=git://igloocommunity.org/git/bsp/b2r2lib.git
b2r2lib-makeflags=CC=$(CROSS_COMPILE:"%"=%)gcc CFLAGS="$(CFLAGS) -I./include" LDFLAGS="$(LDFLAGS)"

ifeq ($(CONFIG_X11),y)
subproject-$(CONFIG_BOARD_SNOWBALL)+=mali_drv
mali_drv-git=git://igloocommunity.org/git/bsp/xorg-x11-drv-ste.git
mali_drv-config=./configure CFLAGS="$(CFLAGS) -I$(objtree)/usr/include/pixman-1" LDFLAGS="$(LDFLAGS)" --prefix=/usr --includedir=/usr/include --host=$(CROSS_COMPILE:%-=%)
endif

xkbcommon-version=0.3.0
ifeq ($(xkbcommon-version),git)
xkbcommon=libxkbcommon
else
xkbcommon=xkbcommon
endif
subproject-$(CONFIG_LIBXKBCOMMON)+=$(xkbcommon)
xkbcommon-url="http://cgit.freedesktop.org/xorg/lib/libxkbcommon/snapshot/xkbcommon-$(xkbcommon-version).tar.gz"
libxkbcommon-git="git://github.com/xkbcommon/libxkbcommon.git"
$(xkbcommon)-configure-arguments= --with-xkb-config-root=/usr/share/xkb

DirectFB-version=1.6.3
subproject-$(CONFIG_DIRECTFB)+=DirectFB
DirectFB-git=git://git.directfb.org/git/directfb/core/DirectFB.git
DirectFB-url=http://directfb.org/downloads/Core/DirectFB-1.6/DirectFB-$(DirectFB-version).tar.gz
DirectFB-mkconfig=$(src)/config/DirectFB.mk
