subproject-$(CONFIG_LIBC_TOOLCHAIN):=libc-toolchain
libc-toolchain-config:=echo configuration 

glibc-version=$(CONFIG_LIBC_GLIBC_VERSION)
subproject-$(CONFIG_LIBC_GLIBC)+=glibc
glibc-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
glibc-url:=http://ftp.gnu.org/gnu/glibc/glibc$(glibc-version).tar.xz
glibc-git:=git://sourceware.org/git/glibc.git

uClibc-version=$(CONFIG_LIBC_UCLIBC_VERSION)
subproject-$(CONFIG_LIBC_UCLIBC)+=uClibc
uClibc-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
uClibc-url:=http://www.uclibc.org/downloads/uClibc-$(CONFIG_LIBC_UCLIBC_VERSION:"%"=%).tar.xz
uClibc-git:=git://git.busybox.net/uClibc.git
uClibc-defconfig:=$(CONFIG_LIBC_UCLIBC_DEFCONFIG:"%"=%)

newlib-version=$(CONFIG_LIBC_NEWLIB_VERSION)
subproject-$(CONFIG_LIBC_NEWLIB)+=newlib
ifeq ($(findstring linaro, $(newlib-version)),linaro)
newlib-url:=https://releases.linaro.org/14.02/components/toolchain/newlib-linaro/newlib-$(newlib-version).tar.bz2
newlib-git:=git://git.linaro.org/toolchain/newlib.git
else
newlib-url:=ftp://sourceware.org/pub/newlib/newlib$(newlib-version).tar.gz
endif
newlib-makeflags:=CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
newlib-configure:=$(CONFIG_LIBC_NEWLIB_CONFIGURE:"%"=%)

bionic-version:=git
subproject-$(CONFIG_LIBC_BIONIC)+=bionic
bionic-git:=git://android.googlesource.com/platform/bionic

linaro-release=$(firstword $(subst -, ,$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)))
gcc-linaro-version=$(CONFIG_CROSS_COMPILE:"%"=%)$(CONFIG_TOOLCHAIN_GCC_VERSION:"%"=-%)-$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)_runtime
gcc-linaro-url=http://launchpad.net/linaro-toolchain-binaries/trunk/$(linaro-release)/+download/gcc-linaro$(gcc-linaro-version:%=-%).tar.bz2
download-$(CONFIG_LINARO_RUNTIME)+=gcc-linaro
install-$(CONFIG_LINARO_RUNTIME)+=lib/$(CONFIG_CROSS_COMPILE:"%"=%)/ usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/
lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/
lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/ FORCE
usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/
usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(CONFIG_CROSS_COMPILE:"%"=%)/ FORCE

musl-version:=$(CONFIG_LIBC_MUSL_VERSION)
subproject-$(CONFIG_LIBC_MUSL_SP):=musl
musl-url:=http://www.musl-libc.org/releases/musl-$(musl-version).tar.gz
musl-git:=git://git.musl-libc.org/musl
musl-configure-arguments:=CC=$(firstword $(CC))
install-$(CONFIG_LIBC_MUSL_SP):=lib/ld-musl-$(ARCH).so.1
lib/ld-musl-$(ARCH).so.1:install-sysroot:=y
lib/ld-musl-$(ARCH).so.1:link:=../usr/lib/libc.so

patchelf-version=0.6
subproject-$(CONFIG_PATCHELF)+=patchelf
patchelf-url=http://hydra.nixos.org/build/1524660/download/3/patchelf-0.6.tar.gz
patchelf-config=./configure --host=$(CROSS_COMPILE:%-=%)

pthread-git:=http://git.savannah.gnu.org/cgit/hurd/libpthread.git/
