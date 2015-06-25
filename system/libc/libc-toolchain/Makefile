cross_compile:=$(strip $(CROSS_COMPILE:%-=%))
toolchain:=$(join $(dir $(sort $(foreach dir,$(subst :, ,$(PATH)),$(realpath $(wildcard $(dir)/$(cross_compile)-gcc))))),..)
arch:=$(strip $(if $(wildcard $(join $(toolchain),/$(cross_compile))),$(cross_compile), $(if $(wildcard $(join $(toolchain),/$(cross_compile)hf)),$(cross_compile)hf)))

directories:=lib usr/lib usr/include
directories:=$(addprefix $(DESTDIR:%=%/),$(directories))
$(directories):
	$(Q)mkdir -p $@

.PHONY:install-header
install-header:  $(libcdir)/usr/include
	$(Q)$(INSTALL) -DrpP $(libcdir)/usr/include/* $(DESTDIR:%=%/)/usr/include

install-header-$(cross_compile):
	$(Q)$(INSTALL) -DrpP $(libcdir)/usr/include/$(cross_compile)/* $(DESTDIR:%=%/)/usr/include

.PHONY:install-lib
install-lib: $(libcdir)/lib/ $(libcdir)/usr/lib/
	$(Q)$(INSTALL) -DrpP $(libcdir)/lib/ $(DESTDIR:%=%/)lib
	$(Q)$(INSTALL) -DrpP $(libcdir)/usr/lib/ $(DESTDIR:%=%/)usr/lib

.PHONY:install
install: $(if $(wildcard $(toolchain)/$(arch)/libc),$(eval libcdir:=$(toolchain)/$(arch)/libc),$(eval libcdir:=$(toolchain)/libc))
install: $(if $(wildcard $(libcdir)/usr/include/$(cross_compile)),$(eval header_cross_copile:=install-header-$(cross_compile)))
install: $(eval ldso=$(wildcard $(libcdir)/lib/ld-*.so))
install: $(directories) install-lib install-header $(header_cross_compile)
	$(Q)echo "$(libcdir)/lib/ld-*.so $(ldso) => $(LDSO)"
	$(Q)ls $(libcdir)/lib/ld*

all:
