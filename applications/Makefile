subproject-$(CONFIG_XBMC)+=xbmc
xbmc-url:=git://github.com/xbmc/xbmc.git
xbmc-config:=$(MAKE) -C $(src)/xbmc ../../config/xbmc_defconfig
xbmc-build:=$(MAKE) -C $(src)/xbmc
xbmc-install:=$(MAKE) -C $(src)/xbmc CONFIG_PREFIX=$(objtree) install

subproject-$(CONFIG_XBMC)+=vlc
vlc-url:=http://download.videolan.org/pub/videolan/vlc/2.0.5/vlc-2.0.5.tar.xz
vlc-config:=$(MAKE) -C $(src)/vlc ../../config/vlc_defconfig
vlc-build:=$(MAKE) -C $(src)/vlc
vlc-install:=$(MAKE) -C $(src)/vlc CONFIG_PREFIX=$(objtree) install

