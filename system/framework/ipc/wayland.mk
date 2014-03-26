wayland-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WAYLAND_LIB)+=wayland
wayland-git="git://anongit.freedesktop.org/wayland/wayland.git"
wayland-url="http://wayland.freedesktop.org/releases/wayland-$(wayland-version).tar.xz"
wayland-configure-arguments= --disable-documentation --disable-scanner --enable-shared
wayland-directory=$(if $(findstring git,$(wayland-version)),wayland,wayland$(wayland-version:%=-%))

download-$(CONFIG_WAYLAND)+=wayland

hostprogs-$(CONFIG_WAYLAND)+=wayland-scanner wayland-scanner.pc 
wayland-scanner-objs=$(wayland-directory)/src/scanner.o $(wayland-directory)/src/wayland-util.o -lexpat
wayland-scanner-install=wayland-scanner wayland-scanner.pc 

pkgdatadir:=$(sysroot)/usr/share/wayland
wayland-scanner.pc:
	@echo prefix=$(rootfs)/usr >> $@
	@echo datarootdir=$(sysroot)/usr/share >> $@
	@echo pkgdatadir=$(pkgdatadir) >> $@
	@echo wayland_scanner=$(hostbin)/wayland-scanner >> $@
	@echo >> $@
	@echo Name: Wayland Scanner >> $@
	@echo Description: Wayland scanner >> $@
	@echo Version: $(wayland-version) >> $@

$(pkgdatadir)/wayland.dtd: $(wayland-directory)/protocol/wayland.dtd
	@cp $< $@
	
$(pkgdatadir)/wayland.xml: $(wayland-directory)/protocol/wayland.xml
	@cp $< $@
