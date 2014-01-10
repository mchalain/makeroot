CONFIGURE_OPTIONS="HOST= BUILD="

subproject-$(CONFIG_GNU)+=zlib
zlib-url:=http://zlib.net/zlib-1.2.7.tar.gz
zlib-config:=cd $(src)/zlib; ./configure --prefix=/usr
zlib-build:=$(MAKE) -C $(src)/zlib
zlib-install:=$(MAKE) -C $(src)/zlib CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_GNU)+=file
file-url:=ftp://ftp.astron.com/pub/file/file-5.11.tar.gz
file-config:=cd $(src)/file; ./configure --prefix=/usr
file-build:=$(MAKE) -C $(src)/file
file-install:=$(MAKE) -C $(src)/file CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_GNU)+=coreutils
coreutils-url:=http://ftp.gnu.org/gnu/coreutils/coreutils-8.20.tar.xz
coreutils-config:=cd $(src)/coreutils; ./configure --prefix=/usr --libexecdir=/usr/lib
coreutils-build:=$(MAKE) -C $(src)/coreutils
coreutils-install:=$(MAKE) -C $(src)/coreutils CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_GNU)+=shadow
shadow-url:=http://pkg-shadow.alioth.debian.org/releases/shadow-4.1.5.tar.gz
shadow-config:=cd $(src)/shadow; ./configure --prefix=/ 
shadow-build:=$(MAKE) -C $(src)/shadow
shadow-install:=$(MAKE) -C $(src)/shadow CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_GNU)+=sysvinit
sysvinit-url:=http://download.savannah.gnu.org/releases/sysvinit/sysvinit-latest.tar.bz2
sysvinit-config:=cd $(src)/sysvinit; ./configure --prefix=/
sysvinit-build:=$(MAKE) -C $(src)/sysvinit
sysvinit-install:=$(MAKE) -C $(src)/sysvinit CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_GNU)+=bash
bash-url:=http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz
bash-config:=cd $(src)/bash; ./configure --prefix=/
bash-build:=$(MAKE) -C $(src)/bash
bash-install:=$(MAKE) -C $(src)/bash CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_GNU)+=util-linux
util-linux-url=https://www.kernel.org/pub/linux/utils/util-linux/v2.22/util-linux-2.22.tar.xz
