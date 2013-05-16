expat-version=2.1.0
subproject-$(CONFIG_EXPAT)+=expat
expat-url="http://sourceforge.net/projects/expat/files/expat/$(expat-version)/expat-$(expat-version).tar.gz"
expat-config=./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --host=$(CROSS_COMPILE:%-=%) --prefix=/usr --with-sysroot=$(objtree)
expat-makeflags= CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" 

subproject-$(CONFIG_LIBFFI)+=libffi
libffi-git="git://github.com/atgreen/libffi.git"
libffi-config=./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=/usr --includedir=/usr/include --host=$(CONFIG_CROSS_COMPILE:"%-"=%)
libffi-makeflags=

install-$(CONFIG_LIBFFI)+=usr/include/ffi.h
usr/include/ffi.h:copy=usr/lib/libffi-3.0.13/include/ffi.h
usr/include/ffi.h:$(objtree)/usr/lib/libffi-3.0.13/include/ffi.h
