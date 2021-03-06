subproject-$(CONFIG_LIBC_TOOLCHAIN)+=libc-toolchain
libc-toolchain-config:=echo configuration 

# during the glibc configuration CPP are looking for limits.h recursivly.
# but no ending limits.h are available. We work around this problem to create an empty limits.h file
# this file will be over write during the installation of the glibc
pre-install-$(CONFIG_LIBC_GLIBC_SP)+=$(SYSTEM)/include/limits.h
$(SYSTEM)/include/limits.h: touch=y
$(SYSTEM)/include/limits.h: install-sysroot:=y
glibc-version=$(CONFIG_LIBC_GLIBC_VERSION)
download-$(CONFIG_LIBC_GLIBC_SP)+=glibc-ports
glibc-ports-url:=http://ftp.gnu.org/gnu/glibc/glibc-ports-$(glibc-version).tar.bz2
subproject-$(CONFIG_LIBC_GLIBC_SP)+=glibc
glibc-url:=http://ftp.gnu.org/gnu/glibc/glibc-$(glibc-version).tar.xz
glibc-git:=git://sourceware.org/git/glibc.git
glibc-makeflags:=MAKEFLAGS="install_root=$(packagesdir)/glibc-$(glibc-version) ld.so-version=$(LDSO)"
glibc-configure-arguments:=--with-headers=$(sysroot)/$(SYSTEM)/include --enable-add-ons=../glibc-ports-$(glibc-version),nptl --config-cache
glibc-configure-arguments+=--disable-profile
# by default applications will be linked with -z now option. At the start, all links are done before running.
# This feature increases the start time of the application but decreases the running time for big application.
glibc-configure-arguments+=--enable-bind-now
# this feature adds random value to the stack protector
glibc-configure-arguments+=--enable-stackguard-randomization
# Thread Local Storage.
glibc-configure-arguments+=--with-tls
glibc-configure-arguments+=--disable-pt_chown
# RPC is no longer supported by glibc but it could be easier to use it for some RPC applications like rpcbind
# look at system/server/Makefile to see new support of old header files as nis.h yp.h mount.h previously into rpcsvc directory
#glibc-configure-arguments+=--enable-obsolete-rpc
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
eglibc-url:=https://releases.linaro.org/$(linaro-version)/components/toolchain/eglibc-linaro/eglibc-$(eglibc-version).tar.bz2
eglibc-git:=git://git.linaro.org/toolchain/eglibc.git
#subproject-$(CONFIG_LIBC_EGLIBC_SP)+=eglibc

sysroot-linaro-eglibc-version=gcc$(CONFIG_TOOLCHAIN_GCC_VERSION)$(CONFIG_LINARO_VERSION:%=-20%)-$(CONFIG_CROSS_COMPILE:"%"=%)
sysroot-linaro-eglibc-url:=http://releases.linaro.org/$(CONFIG_LINARO_VERSION)/components/toolchain/binaries/arm-linux-gnueabihf/sysroot-linaro-eglibc$(eglibc-gcc-linaro-version:%=-%).tar.xz

sysroot-linaro:=system/libc/sysroot-linaro-eglibc$(sysroot-linaro-eglibc-version:%=-%)
subproject-$(CONFIG_LIBC_EGLIBC_SP)+=sysroot-linaro-eglibc
sysroot-linaro-eglibc-config:=true
sysroot-linaro-eglibc-build:=true
sysroot-linaro-eglibc-install:=cp -r * $(packagesdir)/sysroot-linaro-eglibc$(sysroot-linaro-eglibc-version:%=-%)

else
eglibc-version:=$(CONFIG_LIBC_EGLIBC_VERSION)
eglibc-svn:=svn://svn.eglibc.org/branches/eglibc-$(subst .,_,$(eglibc-version))
subproject-$(CONFIG_LIBC_EGLIBC_SP)+=eglibc
eglibc-makeflags:=MAKEFLAGS="install_root=$(packagesdir)/eglibc-$(eglibc-version) install-bootstrap-headers=yes ld.so-version=$(LDSO)"
eglibc-targets:=install-headers all
eglibc-configure-arguments:=--with-headers=$(sysroot)/$(SYSTEM)/include --enable-add-ons=ports,nptl
eglibc-configure-arguments+=--disable-profile
eglibc-configure-arguments+=--without-gd
eglibc-configure-arguments+=--without-cvs
eglibc-configure-arguments+=--disable-build-nscd
eglibc-configure-arguments+=--enable-multi-arch
ifeq (y,$(CONFIG_LIBC_OBSOLETE_RPC))
eglibc-configure-arguments+=--enable-obsolete-rpc
endif
eglibc-builddir:=y
endif

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
install-$(CONFIG_LINARO_RUNTIME)+=lib/$(TRIPLET)/ $(SYSTEM)/lib/$(TRIPLET)/
lib/$(TRIPLET)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(TRIPLET)/
lib/$(TRIPLET)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/lib/$(TRIPLET)/ FORCE
$(SYSTEM)/lib/$(TRIPLET)/: copy=$(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(TRIPLET)/
$(SYSTEM)/lib/$(TRIPLET)/: $(srctree)/$(src)/gcc-linaro$(gcc-linaro-version:%=-%)/usr/lib/$(TRIPLET)/ FORCE

musl-version:=$(CONFIG_LIBC_MUSL_VERSION)
subproject-$(CONFIG_LIBC_MUSL_SP):=musl
musl-url:=http://www.musl-libc.org/releases/musl-$(musl-version).tar.gz
musl-git:=git://git.musl-libc.org/musl
install-$(CONFIG_LIBC_MUSL_SP)+=lib/$(LDSO)
lib/$(LDSO):install-sysroot:=y
lib/$(LDSO):link:=../$(SYSTEM)/lib/libc.so
install-$(CONFIG_LIBC_MUSL_SP)+=gcc.specs
gcc.specs:install-sysroot:=y
gcc.specs:generate:=/tmp/gcc.specs
gcc.specs:/tmp/gcc.specs
/tmp/gcc.specs:incdir:=/$(SYSTEM)/include
/tmp/gcc.specs:libdir:=/$(SYSTEM)/lib
/tmp/gcc.specs:
	$(Q)echo '' > $@
	$(Q)echo '%rename cpp_options old_cpp_options' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*cpp_options:' >> $@
	$(Q)echo '-nostdinc -isystem %R'$(incdir)' -isystem include%s %(old_cpp_options) -D_GNU_SOURCE -D_POSIX_SOURCE -D__USE_GNU' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*cc1:' >> $@
	$(Q)echo '%(cc1_cpu) -nostdinc -isystem %R'$(incdir)' -isystem include%s -D_GNU_SOURCE -D_POSIX_SOURCE -D__USE_GNU' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*link_libgcc:' >> $@
	$(Q)echo '-L%R'$(libdir)' -L .%s' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*libgcc:' >> $@
	$(Q)echo 'libgcc.a%s %:if-exists(libgcc_eh.a%s)' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*startfile:' >> $@
	$(Q)echo '%{!shared: %R'$(libdir)'/%{pie:S}crt1.o} %R'$(libdir)'/crti.o %{shared|pie:crtbeginS.o%s;:crtbegin.o%s}' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*endfile:' >> $@
	$(Q)echo '%{shared|pie:crtendS.o%s;:crtend.o%s} %R'$(libdir)'/crtn.o' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*link:' >> $@
	$(Q)echo '-nostdlib %{shared:-shared} %{static:-static} %{rdynamic:-export-dynamic}' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*lib:' >> $@
	$(Q)echo '-lgcc_eh -lc' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*predefines:' >> $@
	$(Q)echo '-D_GNU_SOURCE -D_POSIX_SOURCE' >> $@
	$(Q)echo '' >> $@
	$(Q)echo '*esp_link:' >> $@
	$(Q)echo '*esp_options:' >> $@
	$(Q)echo '*esp_cpp_options:' >> $@

patchelf-version=0.6
subproject-$(CONFIG_PATCHELF)+=patchelf
patchelf-url=http://hydra.nixos.org/build/1524660/download/3/patchelf-0.6.tar.gz
patchelf-config=./configure --host=$(TRIPLET)

pthread-git:=http://git.savannah.gnu.org/cgit/hurd/libpthread.git/
