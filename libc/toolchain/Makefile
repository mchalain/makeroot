toolchain:=$(CONFIG_TOOLCHAIN:"%"=%)
cross_compile:= $(CONFIG_CROSS_COMPILE:"%"=%)

install-$(CONFIG_LIBC_TOOLCHAIN)+=lib
lib: copy=$(toolchain)/$(cross_compile)/libc/lib/$(cross_compile)
lib: $(toolchain)/$(cross_compile)/libc/lib/$(cross_compile)

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include
usr/include: copy=$(toolchain)/$(cross_compile)/libc/usr/include
usr/include: $(toolchain)/$(cross_compile)/libc/usr/include

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/bits
usr/include/bits: copy=$(toolchain)/$(cross_compile)/libc/usr/include/$(cross_compile)/bits
usr/include/bits: $(toolchain)/$(cross_compile)/libc/usr/include/$(cross_compile)/bits

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/sys
usr/include/sys: copy=$(toolchain)/$(cross_compile)/libc/usr/include/$(cross_compile)/sys
usr/include/sys: $(toolchain)/$(cross_compile)/libc/usr/include/$(cross_compile)/sys

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include/gnu
usr/include/gnu: copy=$(toolchain)/$(cross_compile)/libc/usr/include/$(cross_compile)/gnu
usr/include/gnu: $(toolchain)/$(cross_compile)/libc/usr/include/$(cross_compile)/gnu
