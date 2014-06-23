libpng-version=1.6.2
subproject-$(CONFIG_LIBPNG)+=libpng
libpng-url="http://downloads.sourceforge.net/libpng/libpng$(libpng-version:%=-%).tar.xz"
libpng-git="git://git.code.sf.net/p/libpng/code"
libpng-configure-arguments:=--disable-static
#libpng-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig --host=$(CROSS_COMPILE:%-=%) --prefix=/usr --disable-static
#libpng-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CPPFLAGS="$(CFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

libjpeg-turbo-version=1.2.1
subproject-$(CONFIG_LIBJPEG)+=libjpeg-turbo
libjpeg-turbo-url="http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo$(libjpeg-turbo-version:%=-%).tar.gz"
libjpeg-configure-arguments:=--disable-static
#libjpeg-turbo-config=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig --host=$(CROSS_COMPILE:%-=%) --prefix=/usr --disable-static
#libjpeg-turbo-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CPPFLAGS="$(CFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

pixman-version:=0.30.0
subproject-$(CONFIG_PIXMAN)+=pixman
pixman-url:="http://cairographics.org/releases/pixman$(pixman-version:%=-%).tar.gz"
pixman-git:="http://cgit.freedesktop.org/pixman/pixman.git"
pixman-configure-arguments:=
#pixman-config:=./configure CC="$(CROSS_COMPILE)gcc" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig --host=$(CROSS_COMPILE:%-=%) --prefix=/usr
#pixman-makeflags:=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

freetype-version=2.5.2
subproject-$(CONFIG_FREETYPE)+=freetype
freetype-url:=http://download.savannah.gnu.org/releases/freetype/freetype-$(freetype-version).tar.gz
freetype-configure-arguments:=LIBPNG_CFLAGS=-I$(sysroot)/$(SYSTEM)/lib LIBPNG_LDFLAGS=-lpng16

CAIRO_CONFIGURE_OPTIONS:=
ifeq ($(CONFIG_FREETYPE),y)
CAIRO_CONFIGURE_OPTIONS+=
endif
ifeq ($(CONFIG_EGL),y)
#CAIRO_CONFIGURE_OPTIONS+=--enable-glesv2
endif
ifeq ($(CONFIG_GL),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-gl 
endif
ifeq ($(CONFIG_DRM),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-drm
endif
ifeq ($(CONFIG_DIRECTFB),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-directfb
endif
ifeq ($(CONFIG_QT_GUI),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-qt
endif
ifeq ($(CONFIG_EXPAT),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-xml
endif
ifeq ($(CONFIG_X11),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-xlib
endif
ifeq ($(CONFIG_X11_XCB),y)
CAIRO_CONFIGURE_OPTIONS+= --enable-xlib-xcb  --enable-xcb
endif
ifeq ($(CONFIG_PIXMAN),y)
CAIRO_CONFIGURE_OPTIONS+=
endif
cairo-version=1.12.14
subproject-$(CONFIG_CAIRO)+= cairo
cairo-url=http://cairographics.org/releases/cairo-1.12.14.tar.xz
cairo-configure-arguments:=$(CAIRO_CONFIGURE_OPTIONS)
