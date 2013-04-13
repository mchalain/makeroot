CROSS_COMPILE := $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH := $(CONFIG_ARCH:"%"=%)
export CROSS_COMPILE ARCH


subdir-$(CONFIG_LIBC_TOOLCHAIN):=toolchain

uclibc-version=$(strip $(if $(CONFIG_LIBC_UCLIBC_VERSION:"%"=%),-$(CONFIG_LIBC_UCLIBC_VERSION:"%"=%)))
subproject-$(CONFIG_LIBC_UCLIBC)+=uClibc$(uclibc-version)
uClibc$(uclibc-version)-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
uClibc$(uclibc-version)-url:=http://www.uclibc.org/downloads/uClibc-$(CONFIG_LIBC_UCLIBC_VERSION:"%"=%).tar.xz
uClibc-git-url:=git://git.busybox.net/uClibc.git
uClibc$(uclibc-version)-defconfig:=$(CONFIG_LIBC_UCLIBC_DEFCONFIG:"%"=%)

newlib-version=$(strip $(if $(CONFIG_LIBC_NEWLIB_VERSION:"%"=%),-$(CONFIG_LIBC_NEWLIB_VERSION:"%"=%)))
subproject-$(CONFIG_LIBC_NEWLIB)+=newlib$(newlib-version)
newlib$(newlib-version)-url:=ftp://sourceware.org/pub/newlib/newlib$(newlib-version).tar.gz
newlib$(newlib-version)-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
newlib$(newlib-version)-configure:=$(CONFIG_LIBC_NEWLIB_CONFIGURE:"%"=%)

glibc-version=$(strip $(if $(CONFIG_LIBC_GLIBC_VERSION:"%"=%),-$(CONFIG_LIBC_GLIBC_VERSION:"%"=%)))
subproject-$(CONFIG_LIBC_GLIBC)+=glibc$(glibc-version)
glibc$(glibc-version)-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
glibc$(glibc-version)-url:=http://ftp.gnu.org/gnu/glibc/glibc$(glibc-version).tar.xz
glibc-git-url:=git://sourceware.org/git/glibc.git


bionic-git:=git://android.googlesource.com/platform/bionic.git