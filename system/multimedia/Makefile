lame-version:=$(CONFIG_MM_LAME_VERSION)
subproject-$(CONFIG_MM_LAME_SP)+=lame
lame-url:=http://sourceforge.net/projects/lame/files/lame/3.99/lame-$(lame-version).tar.gz

mpd-version:=0.13.2
subproject-$(CONFIG_MM_MPD)+=mpd
mpd-url:=http://www.musicpd.org/download/mpd/0.13/mpd$(mpd-version:%=-%).tar.xz

gmrender-resurrect-version:=git
subproject-$(CONFIG_MM_GMRENDER_SP):=gmrender-resurrect
gmrender-resurrect-git:=https://github.com/hzeller/gmrender-resurrect.git

mpg123-version:=$(CONFIG_MM_MPG123_VERSION)
subproject-$(CONFIG_MM_MPG123_SP)+=mpg123
mpg123-url:=http://sourceforge.net/projects/mpg123/files/mpg123/$(mpg123-version)/mpg123-$(mpg123-version).tar.bz2
mpg123-configure-arguments:=
mpg123-configure-arguments+=--with-cpu=$(ARCH)$(if $(findstring y,$(HFP)),_fpu,_nofpu)
ifeq (y,$(CONFIG_LOWLEVEL_TINYALSA))
mpg123-configure-arguments+=--with-default-audio=tinyalsa
endif
