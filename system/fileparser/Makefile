expat-version=2.1.0
subproject-$(CONFIG_EXPAT)+=expat
expat-url="http://sourceforge.net/projects/expat/files/expat/$(expat-version)/expat-$(expat-version).tar.gz"
expat-config=./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=/usr --host=$(CONFIG_CROSS_COMPILE:"%-"=%) --with-sysroot=$(objtree)
expat-makeflags= CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc

subproject-$(CONFIG_LIBFFI)+=libffi
libffi-git="git://github.com/atgreen/libffi.git"
libffi-config=./configure CC=$(CONFIG_CROSS_COMPILE:"%"=%)-gcc --prefix=/usr --host=$(CONFIG_CROSS_COMPILE:"%-"=%)
libffi-makeflags=

