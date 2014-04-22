expat-version=2.1.0
subproject-$(CONFIG_EXPAT)+=expat
expat-url="http://sourceforge.net/projects/expat/files/expat/$(expat-version)/expat-$(expat-version).tar.gz"
expat-configure-arguments:=--with-sysroot=$(sysroot)
expat-makeflags= CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" 

libffi-version:=git
subproject-$(CONFIG_LIBFFI)+=libffi
libffi-git="git://github.com/atgreen/libffi.git"
libffi-configure-arguments:=
libffi-makeflags=
