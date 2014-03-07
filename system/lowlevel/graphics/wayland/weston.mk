weston-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WESTON)+=weston
WESTON_CONFIGURE_OPTIONS+= --enable-wayland-compositor --disable-libunwind
ifneq ($(CONFIG_X11),y)
WESTON_CONFIGURE_OPTIONS+=--disable-xwayland --disable-x11-compositor
CFLAGS+=-DMESA_EGL_NO_X11_HEADERS
else
WESTON_CONFIGURE_OPTIONS+=--enable-xwayland --enable-x11-compositor
endif
ifeq ($(CONFIG_PAM),y)
WESTON_CONFIGURE_OPTIONS+=--enable-weston-launch
else
WESTON_CONFIGURE_OPTIONS+=--disable-weston-launch
endif
ifeq ($(CONFIG_RPI),y)
WESTON_CONFIGURE_OPTIONS+=--enable-rpi-compositor
else
WESTON_CONFIGURE_OPTIONS+=--disable-rpi-compositor
endif
ifeq ($(CONFIG_DRM),y)
WESTON_CONFIGURE_OPTIONS+=--enable-drm-compositor
else
WESTON_CONFIGURE_OPTIONS+=--disable-drm-compositor
endif
ifeq ($(CONFIG_FRAMEBUFFER),y)
WESTON_CONFIGURE_OPTIONS+=--enable-fbdev-compositor
else
WESTON_CONFIGURE_OPTIONS+=--disable-fbdev-compositor
endif
ifeq ($(CONFIG_RDP),y)
WESTON_CONFIGURE_OPTIONS+=--enable-rdp-compositor
else
WESTON_CONFIGURE_OPTIONS+=--disable-rdp-compositor
endif
ifneq ($(CONFIG_EGL),y)
WESTON_CONFIGURE_OPTIONS+=--disable-egl --disable-simple-egl-clients
endif
ifeq ($(CONFIG_CAIRO),y)
WESTON_CONFIGURE_OPTIONS+=--enable-clients
ifeq ($(CONFIG_EGL),y)
WESTON_CONFIGURE_OPTIONS+=--with-cairo-glesv2
endif
else
WESTON_CONFIGURE_OPTIONS+=--disable-clients --disable-wcap-tools
endif
ifneq ($(CONFIG_COLORD),y)
WESTON_CONFIGURE_OPTIONS+=--disable-colord
endif
weston-url="http://wayland.freedesktop.org/releases/weston-$(weston-version).tar.xz"
weston-git="git://anongit.freedesktop.org/wayland/weston.git"
weston-configure-arguments=$(WESTON_CONFIGURE_OPTIONS)

