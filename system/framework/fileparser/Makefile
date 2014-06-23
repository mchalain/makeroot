expat-version=2.1.0
subproject-$(CONFIG_FW_EXPAT)+=expat
expat-url="http://sourceforge.net/projects/expat/files/expat/$(expat-version)/expat-$(expat-version).tar.gz"
expat-configure-arguments:=--with-sysroot=$(sysroot)
expat-builddir:=y

libtool-version:=2.4.2
subproject-$(CONFIG_FW_LIBTOOL)+=libtool
libtool-url:=ftp://ftp.gnu.org/gnu/libtool/libtool-$(libtool-version).tar.gz
libtool-git:=git://git.savannah.gnu.org/libtool.git
libtool-builddir:=y

libffi-version:=git
subproject-$(CONFIG_FW_LIBFFI)+=libffi
libffi-git="git://github.com/atgreen/libffi.git"
libffi-configure-arguments:=
libffi-makeflags=
libffi-builddir:=y

pcre-version:=$(CONFIG_FW_PCRE_VERSION)
subproject-$(CONFIG_FW_PCRE_SP)+=pcre
pcre-url=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$(pcre-version).tar.gz
pcre-configure-arguments:=
ifeq (y,$(CONFIG_FW_BZIP2_SP))
pcre-configure-arguments+=--enable-pcregrep-libbz2
endif
ifeq (y,$(CONFIG_FW_ZLIB_SP))
pcre-configure-arguments+=--enable-pcregrep-libz
endif
pcre-makeflags=
pcre-builddir:=y

