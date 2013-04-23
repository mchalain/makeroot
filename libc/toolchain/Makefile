toolchain:=$(CONFIG_TOOLCHAIN:"%"=%)
cross_compile:= $(CONFIG_CROSS_COMPILE:"%"=%)

install-$(CONFIG_LIBC_TOOLCHAIN)+=lib
lib: copy=$(toolchain)/$(cross_compile)/libc/lib/$(cross_compile)
lib: $(toolchain)/$(cross_compile)/libc/lib/$(cross_compile)

install-$(CONFIG_LIBC_TOOLCHAIN)+=usr/include
usr/include: copy=$(toolchain)/$(cross_compile)/libc/usr/include
usr/include: $(toolchain)/$(cross_compile)/libc/usr/include
