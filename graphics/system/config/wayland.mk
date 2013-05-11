WLD:=/usr

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
configure: FORCE
	./configure CC="$(CROSS_COMPILE:%-=%)-gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --prefix=$(WLD) --includedir=/usr/include $(CONFIG_WESTON_OPTIONS:"%"=%) --host=$(CROSS_COMPILE:%-=%)
endif

.PHONY+=build
build: FORCE
	$(MAKE)  CC=$(CROSS_COMPILE:%-=%)-gcc

FORCE:;
