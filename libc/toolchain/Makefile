toolchain:=$(strip $(if $(CONFIG_TOOLCHAIN_EXTERNAL),$(CONFIG_TOOLCHAIN:"%"=%),$(hostobjtree)/toolchain))
cross_compile:=$(strip $(CONFIG_CROSS_COMPILE:"%"=%))
arch:=$(strip $(if $(wildcard $(join $(toolchain),/$(cross_compile))),$(cross_compile), $(if $(wildcard $(join $(toolchain),/$(cross_compile)hf)),$(cross_compile)hf)))

install-$(CONFIG_LIBC_TOOLCHAIN)+=lib
lib: copy=$(toolchain)/$(arch)/libc/lib/$(cross_compile)
lib: $(toolchain)/$(arch)/libc/lib/$(cross_compile)

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include
usr/include: copy=$(toolchain)/$(arch)/libc/usr/include
usr/include: $(toolchain)/$(arch)/libc/usr/include

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/bits
usr/include/bits: copy=$(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/bits
usr/include/bits: $(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/bits

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/sys
usr/include/sys: copy=$(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/sys
usr/include/sys: $(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/sys

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/gnu
usr/include/gnu: copy=$(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/gnu
usr/include/gnu: $(toolchain)/$(arch)/libc/usr/include/$(cross_compile)/gnu
