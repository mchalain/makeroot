
zlib-version=1.2.8
subproject-$(CONFIG_ZLIB)+=zlib
zlib-url="http://zlib.net/zlib$(zlib-version:%=-%).tar.gz"
libpng-git="https://github.com/madler/zlib.git"
zlib-config=./configure --prefix=/usr --shared
zlib-makeflags=CROSS_COMPILE="$(CROSS_COMPILE)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
