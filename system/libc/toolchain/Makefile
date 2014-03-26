toolchain:=$(if $(CONFIG_TOOLCHAIN_PATH:"%"=%),$(CONFIG_TOOLCHAIN_PATH:"%"=%),$(join $(hostobjtree),toolchain))
cross_compile:=$(strip $(CONFIG_CROSS_COMPILE:"%"=%))
arch:=$(strip $(if $(wildcard $(join $(toolchain),/$(cross_compile))),$(cross_compile), $(if $(wildcard $(join $(toolchain),/$(cross_compile)hf)),$(cross_compile)hf)))

install-$(CONFIG_LIBC_TOOLCHAIN)+=lib/
lib/: copy=$(toolchain)/$(arch)/libc/lib/
lib/: $(toolchain)/$(arch)/libc/lib/

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/lib/
usr/lib/: copy=$(toolchain)/$(arch)/libc/usr/lib/
usr/lib/: $(toolchain)/$(arch)/libc/usr/lib/

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include
usr/include: copy=$(toolchain)/$(arch)/libc/usr/include
usr/include: $(toolchain)/$(arch)/libc/usr/include

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/bits
usr/include/bits: link=$(cross_compile)/bits
usr/include/bits: $(sysroot)/usr/include/$(cross_compile)/bits

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/sys
usr/include/sys: link=$(cross_compile)/sys
usr/include/sys: $(sysroot)/usr/include/$(cross_compile)/sys

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/gnu
usr/include/gnu: link=$(cross_compile)/gnu
usr/include/gnu: $(sysroot)/usr/include/$(cross_compile)/gnu
