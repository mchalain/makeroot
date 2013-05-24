libpng-version=1.6.2
subproject-$(CONFIG_LIBPNG)+=libpng
libpng-url="http://downloads.sourceforge.net/libpng/libpng$(libpng-version:%=-%).tar.xz"
libpng-git="git://git.code.sf.net/p/libpng/code"
libpng-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig --host=$(CROSS_COMPILE:%-=%) --prefix=/usr --disable-static
libpng-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CPPFLAGS="$(CFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

libjpeg-turbo-version=1.2.1
subproject-$(CONFIG_LIBJPEG)+=libjpeg-turbo
libjpeg-turbo-url="http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo$(libjpeg-turbo-version:%=-%).tar.gz"
libjpeg-turbo-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig --host=$(CROSS_COMPILE:%-=%) --prefix=/usr --disable-static
libjpeg-turbo-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CPPFLAGS="$(CFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

pixman-version=0.30.0
subproject-$(CONFIG_PIXMAN)+=pixman
pixman-url="http://cairographics.org/releases/pixman$(pixman-version:%=-%).tar.gz"
pixman-git="http://cgit.freedesktop.org/pixman/pixman.git"
pixman-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig --host=$(CROSS_COMPILE:%-=%) --prefix=/usr
pixman-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

