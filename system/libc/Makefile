subproject-$(CONFIG_LIBC_TOOLCHAIN):=libc-toolchain
libc-toolchain-config:=echo configuration 

glibc-version=$(CONFIG_LIBC_GLIBC_VERSION)
download-$(CONFIG_LIBC_GLIBC_SP)+=glibc-ports
glibc-ports-url:=http://ftp.gnu.org/gnu/glibc/glibc-ports-$(glibc-version).tar.bz2
subproject-$(CONFIG_LIBC_GLIBC_SP)+=glibc
glibc-url:=http://ftp.gnu.org/gnu/glibc/glibc-$(glibc-version).tar.xz
glibc-git:=git://sourceware.org/git/glibc.git
glibc-makeflags:=MAKEFLAGS="install_root=$(packagesdir)/glibc-$(glibc-version)"
glibc-configure-arguments:=--with-headers=$(sysroot)/usr/include --enable-add-ons=../glibc-ports-$(glibc-version),nptl --config-cache
glibc-configure-arguments+=--disable-profile
# by default applications will be linked with -z now option. At the start, all links are done before running.
# This feature increases the start time of the application but decreases the running time for big application.
glibc-configure-arguments+=--enable-bind-now
# this feature adds random value to the stack protector
glibc-configure-arguments+=--enable-stackguard-randomization
# Thread Local Storage.
glibc-configure-arguments+=--with-tls
glibc-configure-arguments+=--disable-pt_chown
glibc-builddir:=y
# the previous --config-cache argument requires the file $(src)/build-glibc-$(glibc-version)/config.cache that we generate here.
pre-install-$(CONFIG_LIBC_GLIBC_SP)+=/tmp/config.cache
/tmp/config.cache: copy=$(src)/build-glibc-$(glibc-version)/config.cache
/tmp/config.cache: $(src)/build-glibc-$(glibc-version)/config.cache
$(src)/build-glibc-$(glibc-version)/config.cache: $(src)/build-glibc-$(glibc-version)
	@echo "libc_cv_forced_unwind=yes" > $@
	@echo "libc_cv_c_cleanup=yes" >> $@
$(src)/build-glibc-$(glibc-version):
	@mkdir $@

ifeq (y,$(CONFIG_LINARO))
linaro-version:=$(CONFIG_LINARO_VERSION:"%"=%)
eglibc-version:=linaro-$(CONFIG_LIBC_EGLIBC_VERSION)-$(linaro-version:%=20%)
eglibc-url=https://releases.linaro.org/$(linaro-version)/components/toolchain/eglibc-linaro/eglibc-$(eglibc-version).tar.bz2
else
eglibc-version:=$(CONFIG_LIBC_EGLIBC_VERSION)
eglibc-svn:=svn://svn.eglibc.org/branches/eglibc-$(subst .,_,$(eglibc-version))
endif
subproject-$(CONFIG_LIBC_EGLIBC_SP):=eglibc
eglibc-configure-arguments:=--with-headers=$(sysroot)/usr/include --enable-add-ons=../glibc-ports-2.16.0,nptl --disable-profile --without-gd --without-cvs
eglibc-builddir:=y

uClibc-version=$(CONFIG_LIBC_UCLIBC_VERSION)
subproject-$(CONFIG_LIBC_UCLIBCv)+=uClibc
uClibc-url:=http://www.uclibc.org/downloads/uClibc-$(uClibc-version).tar.xz
uClibc-git:=git://git.busybox.net/uClibc.git
uClibc-defconfig:=$(CONFIG_LIBC_UCLIBC_DEFCONFIG:"%"=%)

ifeq (y,$(CONFIG_LINARO))
newlib-version=linaro-$(CONFIG_LIBC_NEWLIB_VERSION)-$(linaro-version:%=20%)
newlib-url:=https://releases.linaro.org/14.02/components/toolchain/newlib-linaro/newlib-$(newlib-version).tar.bz2
newlib-git:=git://git.linaro.org/toolchain/newlib.git
else
newlib-version=$(CONFIG_LIBC_NEWLIB_VERSION)
newlib-url:=ftp://sourceware.org/pub/newlib/newlib$(newlib-version).tar.gz
endif
subproject-$(CONFIG_LIBC_NEWLIB_SP)+=newlib
newlib-configure:=$(CONFIG_LIBC_NEWLIB_CONFIGURE:"%"=%)

bionic-version:=git
subproject-$(CONFIG_LIBC_BIONIC)+=bionic
bionic-git:=git://android.googlesource.com/platform/bionic

dietlibc-version=$(CONFIG_LIBC_DIETLIBC_VERSION)
subproject-$(CONFIG_LIBC_DIETLIBC_SP)+=dietlibc
dietlibc-url:=http://www.fefe.de/dietlibc/dietlibc-$(dietlibc-version).tar.bz2
dietlibc-cvs:=:pserver:cvs@cvs.fefe.de:/cvs

linaro-release=$(firstword $(subst -, ,$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)))
gcc-linaro-version=$(CONFIG_CROSS_COMPILE:"%"=%)$(CONFIG_TOOLCHAIN_GCC_VERSION:"%"=-%)-$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)_runtime
gcc-linaro-url=http://launchpad.net/linaro-toolchain-binaries/trunk/$(linaro-release)/+download/gcc-linaro$(gcc-linaro-version:%=-%).tar.bz2
download-$(CONFIG_LINARO_RUNTIME)+=gcc-linaro
install-$(CONFIG_LINARO_RUNTIME)+=lib/$(TRIPLET)/ usr/lib/$(TRIPLET)/
lib/$(TRIPLET)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(TRIPLET)/
lib/$(TRIPLET)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(TRIPLET)/ FORCE
usr/lib/$(TRIPLET)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(TRIPLET)/
usr/lib/$(TRIPLET)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(TRIPLET)/ FORCE

musl-version:=$(CONFIG_LIBC_MUSL_VERSION)
subproject-$(CONFIG_LIBC_MUSL_SP):=musl
musl-url:=http://www.musl-libc.org/releases/musl-$(musl-version).tar.gz
musl-git:=git://git.musl-libc.org/musl
install-$(CONFIG_LIBC_MUSL_SP):=lib/ld-musl-$(ARCH).so.1
lib/ld-musl-$(ARCH).so.1:install-sysroot:=y
lib/ld-musl-$(ARCH).so.1:link:=../usr/lib/libc.so

patchelf-version=0.6
subproject-$(CONFIG_PATCHELF)+=patchelf
patchelf-url=http://hydra.nixos.org/build/1524660/download/3/patchelf-0.6.tar.gz
patchelf-config=./configure --host=$(TRIPLET)

pthread-git:=http://git.savannah.gnu.org/cgit/hurd/libpthread.git/
