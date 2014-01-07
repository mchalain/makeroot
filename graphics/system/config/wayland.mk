WLD:=/usr

include $(CONFIG)

all: configure

.PHONY+=clean
clean: FORCE
	$(MAKE) clean

.PHONY+=configure
ifeq ($(findstring wayland,$(notdir $(CURDIR))),wayland)
configure: FORCE
	$(Q)$(if $(wildcard configure),,autoreconf --force -v --install)
	$(Q) ./configure CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --prefix=$(WLD) --includedir=/usr/include --host=$(CROSS_COMPILE:%-=%) --disable-documentation
endif
ifeq ($(findstring xkbcommon,$(notdir $(CURDIR))),xkbcommon)
configure: FORCE
	$(Q) ./autogen.sh --prefix=$(WLD) --includedir=/usr/include --with-xkb-config-root=$(WLD)/share/xkb --host=$(CROSS_COMPILE:%-=%)
endif

ifeq ($(findstring weston,$(notdir $(CURDIR))),weston)
WESTON_CONFIGURE_OPTIONS:=--prefix=$(WLD) --includedir=/usr/include
WESTON_CONFIGURE_OPTIONS+=--host=$(CROSS_COMPILE:%-=%)
WESTON_CONFIGURE_OPTIONS+= --enable-wayland-compositor
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
WESTON_CONFIGURE_OPTIONS+=--enable-rpi-compositor
ifeq ($(CONFIG_CAIRO),y)
WESTON_CONFIGURE_OPTIONS+=--enable-clients --with-cairo-glesv2
else
WESTON_CONFIGURE_OPTIONS+=--disable-clients --disable-wcap-tools
endif
ifneq ($(CONFIG_COLORD),y)
WESTON_CONFIGURE_OPTIONS+=--disable-colord
endif
configure: FORCE
	$(Q)$(if $(wildcard configure),,autoreconf --force -v --install)
	$(Q) ./configure CFLAGS="$(CFLAGS) -I$(objtree)/usr/include/drm -I$(objtree)/usr/include/cairo -I$(objtree)/usr/include/pixman-1" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig \
		$(WESTON_CONFIGURE_OPTIONS) $(CONFIG_WESTON_OPTIONS:"%"=%)
endif

.PHONY+=build
build: FORCE
	$(MAKE)  CC=$(CROSS_COMPILE:%-=%)-gcc

FORCE:;
