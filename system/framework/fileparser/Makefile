expat-version=2.1.0
subproject-$(CONFIG_EXPAT)+=expat
expat-url="http://sourceforge.net/projects/expat/files/expat/$(expat-version)/expat-$(expat-version).tar.gz"
expat-configure-arguments:=--with-sysroot=$(sysroot)
expat-builddir:=y

libtool-version:=2.4.2
subproject-$(CONFIG_FW_LIBTOOL)+=libtool
libtool-url:=ftp://ftp.gnu.org/gnu/libtool/libtool-$(libtool-version).tar.gz
libtool-git:=git://git.savannah.gnu.org/libtool.git

libffi-version:=git
subproject-$(CONFIG_LIBFFI)+=libffi
libffi-git="git://github.com/atgreen/libffi.git"
libffi-configure-arguments:=
libffi-makeflags=
