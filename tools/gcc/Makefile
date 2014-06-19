gcc-version=$(CONFIG_TOOLCHAIN_GCC_VERSION:"%"=%)

ifeq ($(CONFIG_TOOLCHAIN_INSTALL),y)
bare-metal-version=$(gcc-version)
toolchain-$(CONFIG_TOOLCHAIN_BARE_METAL):=bare-metal$(bare-metal-version)
bare-metal-4.6-url=https://launchpad.net/gcc-arm-embedded/$(gcc-version)/$(gcc-version)-2012-q2-update/+download/gcc-arm-none-eabi-4_6-2012q2-20120614.tar.bz2
bare-metal-4.7-url=https://launchpad.net/gcc-arm-embedded/$(gcc-version)/$(gcc-version)-2012-q4-major/+download/gcc-arm-none-eabi-4_7-2012q4-20121208-linux.tar.bz2

linaro-release=$(firstword $(subst -, ,$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)))
gcc-linaro-version=$(CONFIG_CROSS_COMPILE:"%"=%)$(gcc-version:%=-%)-$(CONFIG_TOOLCHAIN_LINARO_VERSION:"%"=%)_linux
toolchain-$(CONFIG_TOOLCHAIN_LINARO):=gcc-linaro
gcc-linaro-url=http://launchpad.net/linaro-toolchain-binaries/trunk/$(linaro-release)/+download/gcc-linaro$(gcc-linaro-version:%=-%).tar.bz2

toolchain-$(CONFIG_TOOLCHAIN_SOURCERY_LINUX):=sourcery-linux
ifeq ($(CONFIG_ARM),y)
sourcery-linux-url=https://sourcery.mentor.com/GNUToolchain/package10931/public/arm-none-linux-gnueabi/arm-2012.09-64-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
endif
ifeq ($(CONFIG_MIPS),y)
sourcery-linux-url=https://sourcery.mentor.com/GNUToolchain/package11081/public/mips-linux-gnu/mips-2012.09-99-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
endif
endif

libelf-version:=0.8.13
libelf-url:=http://www.mr511.de/software/libelf-$(libelf-version).tar.gz
libelf-configure-arguments:=--prefix=/tmp
libelf-configure-arguments+=--disable-shared

gmp-version:=4.3.2
gmp-url:=ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-$(gmp-version).tar.gz
gmp-configure-arguments:=--prefix=/tmp
gmp-configure-arguments+=--disable-shared

mpfr-version:=2.4.2
mpfr-url:=ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-$(mpfr-version).tar.gz
mpfr-configure-arguments:=--prefix=/tmp
mpfr-configure-arguments+=--with-gmp=$(src)/$(toolchain_path)/tmp
mpfr-configure-arguments+=--disable-shared

mpc-version:=0.8.1
mpc-url:=ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-$(mpc-version).tar.gz
mpc-configure-arguments:=--prefix=/tmp
mpc-configure-arguments+=--with-gmp=$(src)/$(toolchain_path)/tmp
mpc-configure-arguments+=--with-mpfr=$(src)/$(toolchain_path)/tmp
mpc-configure-arguments+=--disable-shared

gcc-url:=ftp://gcc.gnu.org/pub/gcc/releases/gcc-$(gcc-version)/gcc-$(gcc-version).tar.bz2
gcc-dependencies:=gmp mpfr mpc libelf
gcc-build-dir:=y
gcc-targets:=all-gcc all-target-libgcc install-gcc install-target-libgcc
gcc-configure-arguments:=--target=$(TRIPLET) --prefix=/
gcc-configure-arguments+=--with-build-sysroot=$(src)/$(toolchain_path)/$(sysroot)
gcc-configure-arguments+=--enable-languages=c,c++,lto --enable-lto
gcc-configure-arguments+=--disable-multilib --disable-nls
gcc-configure-arguments+=--disable-shared
gcc-configure-arguments+=--disable-libssp --disable-libstdcxx-pch --disable-libmudflap --disable-libquadmath --enable-libstdcxx-time 
gcc-configure-arguments+=--enable-c99 --enable-long-long --enable-threads=posix
gcc-configure-arguments+=--with-build-time-tools=$(src)/$(toolchain_path)/bin
gcc-configure-arguments+=--oldincludedir=$(src)/$(toolchain_path)/$(sysroot)/usr/include
gcc-configure-arguments+=--with-arch=$(SUBARCH) --with-fpu=$(if $(findstring y,$(HFP)),vfp,soft) --with-float=$(if $(findstring y,$(HFP)),hard,soft)
gcc-configure-arguments+=$(foreach part,$(gcc-dependencies),--with-$(part)=$(src)/$(toolchain_path)/tmp/)
