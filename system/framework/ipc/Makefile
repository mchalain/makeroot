include $(src)/wayland.mk

linux-fusion-version=9.0.0
subproject-$(CONFIG_LINUX_FUSION)+=linux-fusion
linux-fusion-git=git://git.directfb.org/git/directfb/core/linux-fusion.git
linux-fusion-url=http://directfb.org/downloads/Core/linux-fusion/linux-fusion-$(linux-fusion-version).tar.gz
linux-fusion-mkconfig=$(src)/config/linux-fusion.mk

libevent-version:=$(CONFIG_FW_IPC_LIBEVENT_VERSION)
subproject-$(CONFIG_FW_IPC_LIBEVENT_SP)+=libevent
libevent-url:=https://github.com/downloads/libevent/libevent/libevent$(libevent-version:%=-%).tar.gz
libevent-git:=git://levent.git.sourceforge.net/gitroot/levent/libevent
#libevent-git:=https://github.com/libevent/libevent.git
libevent-configure-arguments:=--enable-shared
ifneq ($(CONFIG_SECURITY_OPENSSL),y)
libevent-configure-arguments+=--disable-openssl
endif
