maemo_flasher-version:=3.5_2.5.2.2
subproject-$(CONFIG_BOARD_BEAGLE)+=maemo_flasher
maemo_flasher-url:=http://tablets-dev.nokia.com/maemo-dev-env-downloads.php?f=maemo_flasher-3.5_2.5.2.2.tar.gz
maemo_flasher-makeflags=CC=gcc LD=gcc CFLAGS= LDFLAGS=

xalan-version:=j_2_7_2
subproject-$(CONFIG_BOARD_SNOWBALL)+=xalan
xalan-url:=ftp://mirrors.ircam.fr/pub/apache/xalan/xalan-j/binaries/xalan-$(xalan-version)-bin.tar.gz
xalan-config:=echo done
xalan-build:=echo done
xalan-install:= cd ../riff-loader-communication/lcmodule/tools && rm -rf xalan-j_2_7_1 && ln -s ../../../xalan-$(xalan-version) xalan-j_2_7_1

riff-loader-communication-version:=git
#riff-loader-communication-version:=0.5.2-igloo2
subproject-$(CONFIG_BOARD_SNOWBALL)+=riff-loader-communication
riff-loader-communication-git:=-b build-fixes https://github.com/igloocommunity/riff-loader-communication.git
riff-loader-communication-url:=https://launchpad.net/~igloocommunity-maintainers/+archive/ubuntu/snowball-tools/+files/libloadercomm_$(riff-loader-communication-version).tar.gz
riff-loader-communication-makeflags=CC=gcc LD=gcc
riff-loader-communication-config=make config
riff-loader-communication-targets=build

riff-version:=git
#riff-version:=0.5.2-igloo1
subproject-$(CONFIG_BOARD_SNOWBALL)+=riff
riff-git:=https://github.com/igloocommunity/riff.git
riff-url:=https://launchpad.net/~igloocommunity-maintainers/+archive/ubuntu/snowball-tools/+files/riff_$(riff-version).tar.gz
riff-makeflags=CC=gcc LD=gcc CPPFLAGS="-I$(srctree)/$(src)/riff-loader-communication/source -Duint8=__uint8_t" CFLAGS= LDFLAGS= PREFIX=$(hostobjtree)
riff-config=echo done

riff-configpack-version:=0.5.0-igloo1
subproject-$(CONFIG_BOARD_SNOWBALL)+=riff-configpack
riff-configpack-url:=https://launchpad.net/~igloocommunity-maintainers/+archive/ubuntu/snowball-tools/+files/riff-configpack_$(riff-configpack-version).tar.gz
