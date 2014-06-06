subdir-y+=$(src)/filecompressor

subdir-y+=$(src)/fileparser

ncurses-version:=$(CONFIG_FW_NCURSES_VERSION)
subproject-$(CONFIG_FW_NCURSES_SP)+=ncurses
ncurses-url:=http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$(ncurses-version).tar.gz

SDL2-version:=$(CONFIG_FW_SDL_VERSION)
subproject-$(CONFIG_FW_SDL_SP)+=SDL2
SDL2-url:=http://www.libsdl.org/release/SDL2-$(SDL2-version).tar.gz
SDL2-hg:=http://hg.libsdl.org/SDL
SDL2-configure-arguments:=
ifneq (y,$(CONFIG_UDEV_DAEMON))
SDL2-configure-arguments+=--disable-libudev
endif

subdir-y+=$(src)/images

subdir-y+=$(src)/video

