
zlib-version=$(CONFIG_FW_ZLIB_VERSION)
subproject-$(CONFIG_FW_ZLIB_SP)+=zlib
zlib-url=http://zlib.net/zlib$(zlib-version:%=-%).tar.gz
zlib-git=https://github.com/madler/zlib.git
zlib-config:=./configure --prefix=/$(SYSTEM) --shared

bzip2-version=$(CONFIG_FW_BZIP2_VERSION)
subproject-$(CONFIG_FW_BZIP2_SP)+=bzip2
bzip2-url=http://www.bzip.org/1.0.6/bzip2-$(bzip2-version).tar.gz
bzip2-makeflags:=CC=$(CC) CFLAGS="$(CFLAGS) -fpic -fPIC -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64" PREFIX=/$(SYSTEM)
bzip2-config:=make $(bzip2-makeflags) -f Makefile-libbz2_so
bzip2-install:=make $(bzip2-makeflags) PREFIX=$(packagesdir)/bzip2-$(bzip2-version)/$(SYSTEM) install
bzip2-targets:=bzip2 bzip2recover
install-$(CONFIG_FW_BZIP2_SP)+=$(SYSTEM)/lib/libbz2.so.$(bzip2-version) $(SYSTEM)/lib/libbz2.so
usr/lib/libbz2.so.$(bzip2-version):copy:=$(src)/bzip2-$(bzip2-version)/libbz2.so.$(bzip2-version)
usr/lib/libbz2.so.$(bzip2-version):install-sysroot:=y
usr/lib/libbz2.so:link:=libbz2.so.$(bzip2-version)
usr/lib/libbz2.so:install-sysroot:=y
