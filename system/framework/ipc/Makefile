include $(src)/wayland.mk

linux-fusion-version=9.0.0
subproject-$(CONFIG_LINUX_FUSION)+=linux-fusion
linux-fusion-git=git://git.directfb.org/git/directfb/core/linux-fusion.git
linux-fusion-url=http://directfb.org/downloads/Core/linux-fusion/linux-fusion-$(linux-fusion-version).tar.gz
linux-fusion-mkconfig=$(src)/config/linux-fusion.mk

libevent-version:=2.0.21-stable
subproject-$(CONFIG_LIBEVENT)+=libevent
libevent-url:=https://github.com/downloads/libevent/libevent/libevent$(libevent-version:%=-%).tar.gz
libevent-git:=git://levent.git.sourceforge.net/gitroot/levent/libevent
#libevent-git:=https://github.com/libevent/libevent.git
