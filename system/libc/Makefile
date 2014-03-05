CROSS_COMPILE := $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH := $(CONFIG_ARCH:"%"=%)
export CROSS_COMPILE ARCH

subdir-$(CONFIG_LIBC_TOOLCHAIN):=$(src)/toolchain

uclibc-version=$(strip $(if $(CONFIG_LIBC_UCLIBC_VERSION:"%"=%),$(CONFIG_LIBC_UCLIBC_VERSION:"%"=%)))
subproject-$(CONFIG_LIBC_UCLIBC)+=uClibc
uClibc-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
uClibc-url:=http://www.uclibc.org/downloads/uClibc-$(CONFIG_LIBC_UCLIBC_VERSION:"%"=%).tar.xz
uClibc-git:=git://git.busybox.net/uClibc.git
uClibc-defconfig:=$(CONFIG_LIBC_UCLIBC_DEFCONFIG:"%"=%)

newlib-version=$(strip $(if $(CONFIG_LIBC_NEWLIB_VERSION:"%"=%),$(CONFIG_LIBC_NEWLIB_VERSION:"%"=%)))
subproject-$(CONFIG_LIBC_NEWLIB)+=newlib
newlib-url:=ftp://sourceware.org/pub/newlib/newlib$(newlib-version).tar.gz
newlib-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
newlib-configure:=$(CONFIG_LIBC_NEWLIB_CONFIGURE:"%"=%)

glibc-version=$(strip $(if $(CONFIG_LIBC_GLIBC_VERSION:"%"=%),$(CONFIG_LIBC_GLIBC_VERSION:"%"=%)))
subproject-$(CONFIG_LIBC_GLIBC)+=glibc
glibc-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
glibc-url:=http://ftp.gnu.org/gnu/glibc/glibc$(glibc-version).tar.xz
glibc-git:=git://sourceware.org/git/glibc.git

bionic-version:=git
subproject-$(CONFIG_LIBC_BIONIC)+=bionic
bionic-git:=https://android.googlesource.com/platform/bionic

linaro-release=$(firstword $(subst -, ,$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)))
gcc-linaro-version=$(CONFIG_CROSS_COMPILE:"%"=%)$(CONFIG_TOOLCHAIN_GCC_VERSION:"%"=-%)-$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)_runtime
gcc-linaro-url=http://launchpad.net/linaro-toolchain-binaries/trunk/$(linaro-release)/+download/gcc-linaro$(gcc-linaro-version:%=-%).tar.bz2
download-$(CONFIG_LINARO_RUNTIME)+=gcc-linaro
install-$(CONFIG_LINARO_RUNTIME)+=lib/$(CONFIG_CROSS_COMPILE:"%"=%)/ usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/
lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/
lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/ FORCE
usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/
usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/ FORCE

patchelf-version=0.6
subproject-y+=patchelf
patchelf-url=http://hydra.nixos.org/build/1524660/download/3/patchelf-0.6.tar.gz
patchelf-config=./configure --host=$(CROSS_COMPILE:%-=%)
