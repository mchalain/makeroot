toolchain:=$(CONFIG_TOOLCHAIN:"%"=%)
cross_compile:= $(CONFIG_CROSS_COMPILE:"%"=%)

dirs-$(CONFIG_LIBC_TOOLCHAIN)+=$(toolchain)/$(cross_compile)/libc/lib/$(cross_compile)
$(toolchain)/$(cross_compile)/libc/lib/$(cross_compile)-copy:=lib
dirs-$(CONFIG_LIBC_TOOLCHAIN)+=$(toolchain)/$(cross_compile)/libc/usr/include
$(toolchain)/$(cross_compile)/libc/usr/include-copy:=usr/include
