pixman-version=0.30.0
subproject-$(CONFIG_PIXMAN)+=pixman
pixman-url="http://cairographics.org/releases/pixman-$(pixman-version).tar.gz"
pixman-git="http://cgit.freedesktop.org/pixman/pixman.git"
pixman-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --host=$(CROSS_COMPILE:%-=%) --prefix=/usr
pixman-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

libpng-version=1.6.2
subproject-$(CONFIG_LIBPNG)+=libpng
libpng-url="http://downloads.sourceforge.net/libpng/libpng-1.6.2.tar.xz"
libpng-git="git://git.code.sf.net/p/libpng/code"
libpng-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --host=$(CROSS_COMPILE:%-=%) --disable-static
libpng-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CPPFLAGS="$(CFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

