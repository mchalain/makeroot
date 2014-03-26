cross_compile:=$(strip $(CROSS_COMPILE:%-=%))
toolchain:=$(join $(dir $(sort $(foreach dir,$(subst :, ,$(PATH)),$(realpath $(wildcard $(dir)/$(cross_compile)-gcc))))),..)
arch:=$(strip $(if $(wildcard $(join $(toolchain),/$(cross_compile))),$(cross_compile), $(if $(wildcard $(join $(toolchain),/$(cross_compile)hf)),$(cross_compile)hf)))

directories:=/lib /usr/lib /usr/include
directories:=$(addprefix $(DESTDIR),$(directories))
$(directories):
	@mkdir -p $@

.PHONY:install-header
install-header:  $(toolchain)/$(arch)/libc/usr/include
	@rm $(toolchain)/$(arch)/libc/usr/include/bits
	@ln -s $(cross_compile)/bits $(toolchain)/$(arch)/libc/usr/include/bits
	@rm $(toolchain)/$(arch)/libc/usr/include/sys
	@ln -s $(cross_compile)/sys $(toolchain)/$(arch)/libc/usr/include/sys
	@rm $(toolchain)/$(arch)/libc/usr/include/gnu
	@ln -s $(cross_compile)/gnu $(toolchain)/$(arch)/libc/usr/include/gnu
	@cp -r $(toolchain)/$(arch)/libc/usr/include/* $(DESTDIR)/usr/include

.PHONY:install-lib
install-lib: $(toolchain)/$(arch)/libc/lib/ $(toolchain)/$(arch)/libc/usr/lib/
	@cp -r $(toolchain)/$(arch)/libc/lib/* $(DESTDIR)/lib
	@cp -r $(toolchain)/$(arch)/libc/usr/lib/* $(DESTDIR)/usr/lib

.PHONY:install
install: $(directories) install-lib install-header

all:
