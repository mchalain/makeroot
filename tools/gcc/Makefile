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

toolchain-$(CONFIG_TOOLCHAIN_SOURCERY):=sourcery
ifeq ($(CONFIG_ARM),y)
sourcery-url=https://sourcery.mentor.com/GNUToolchain/package10931/public/arm-none-linux-gnueabi/arm-2012.09-64-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
endif
ifeq ($(CONFIG_MIPS),y)
sourcery-url=https://sourcery.mentor.com/GNUToolchain/package11081/public/mips-linux-gnu/mips-2012.09-99-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
endif
endif

