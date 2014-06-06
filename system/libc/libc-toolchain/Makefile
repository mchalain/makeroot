cross_compile:=$(strip $(CROSS_COMPILE:%-=%))
toolchain:=$(join $(dir $(sort $(foreach dir,$(subst :, ,$(PATH)),$(realpath $(wildcard $(dir)/$(cross_compile)-gcc))))),..)
arch:=$(strip $(if $(wildcard $(join $(toolchain),/$(cross_compile))),$(cross_compile), $(if $(wildcard $(join $(toolchain),/$(cross_compile)hf)),$(cross_compile)hf)))

directories:=lib usr/lib usr/include
directories:=$(addprefix $(DESTDIR:%=%/),$(directories))
$(directories):
	$(Q)mkdir -p $@

.PHONY:install-header
install-header:  $(toolchain)/$(arch)/libc/usr/include
	$(Q)$(INSTALL) -DrpP $(toolchain)/$(arch)/libc/usr/include/* $(DESTDIR:%=%/)/usr/include
	$(Q)rm -rf $(DESTDIR:%=%/)/usr/include/sys
	$(Q)$(INSTALL) -d $(DESTDIR:%=%/)/usr/include/sys
	$(Q)$(INSTALL) -DrpP $(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/sys/* $(DESTDIR:%=%/)/usr/include/sys

.PHONY:install-lib
install-lib: $(toolchain)/$(arch)/libc/lib/ $(toolchain)/$(arch)/libc/usr/lib/
	$(Q)$(INSTALL) -DrpP $(toolchain)/$(arch)/lib $(DESTDIR:%=%/)lib
	$(Q)$(INSTALL) -DrpP $(toolchain)/$(arch)/libc/lib/ $(DESTDIR:%=%/)lib
	$(Q)$(INSTALL) -DrpP $(toolchain)/$(arch)/libc/usr/lib/ $(DESTDIR:%=%/)usr/lib

.PHONY:install
install: $(directories) install-lib install-header
	echo $(DESTDIR)
	echo $(toolchain)
	echo $(arch)

all:
