WLD:=/usr

wayland-version=$(CONFIG_WAYLAND_VERSION:"%"=%)
subproject-$(CONFIG_WAYLAND_LIB)+=wayland
wayland-git="git://anongit.freedesktop.org/wayland/wayland.git"
wayland-url="http://wayland.freedesktop.org/releases/wayland-$(wayland-version).tar.xz"
wayland-configure-arguments= --disable-documentation --disable-scanner
wayland-directory=$(if $(findstring git,$(wayland-version)),wayland,wayland$(wayland-version:%=-%))

ifneq ($(wildcard $(wayland-directory)),)
hostprogs-$(CONFIG_WAYLAND)+=wayland-scanner
wayland-scanner-url=$(wayland-url)
wayland-scanner-objs=$(wayland-directory)/src/scanner.o $(wayland-directory)/src/wayland-util.o -lexpat
wayland-scanner-install=wayland-scanner
endif

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
