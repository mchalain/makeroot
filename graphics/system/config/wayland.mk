WLD:=/usr

include $(CONFIG)

all: configure

.PHONY+=clean
clean: FORCE
	$(MAKE) clean

.PHONY+=configure
ifeq ($(notdir $(CURDIR)),wayland-1.1.0)
configure: FORCE
	./configure CC="$(CROSS_COMPILE:%-=%)-gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --prefix=$(WLD) --includedir=/usr/include --host=$(CROSS_COMPILE:%-=%) --disable-scanner --disable-documentation
endif
ifeq ($(notdir $(CURDIR)),xkbcommon-0.3.0)
configure: FORCE
	./autogen.sh --prefix=$(WLD) --includedir=/usr/include --with-xkb-config-root=$(WLD)/share/xkb --host=$(CROSS_COMPILE:%-=%)
endif

ifeq ($(notdir $(CURDIR)),weston-1.1.0)
WESTON_CONFIGURE_OPTIONS:=--prefix=$(WLD) --includedir=/usr/include
WESTON_CONFIGURE_OPTIONS+=--host=$(CROSS_COMPILE:%-=%)
ifneq ($(CONFIG_X11),y)
WESTON_CONFIGURE_OPTIONS+=--disable-xwayland --disable-x11-compositor
endif
WESTON_CONFIGURE_OPTIONS+=--enable-rpi-compositor --enable-clients
configure: FORCE
	./configure CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" $(WESTON_CONFIGURE_OPTIONS) $(CONFIG_WESTON_OPTIONS:"%"=%)
endif

.PHONY+=build
build: FORCE
	$(MAKE)  CC=$(CROSS_COMPILE:%-=%)-gcc

FORCE:;
