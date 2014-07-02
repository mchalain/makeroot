tinyalsa-version:=git
subproject-$(CONFIG_LOWLEVEL_TINYALSA)+=tinyalsa
tinyalsa-git:=https://github.com/tinyalsa/tinyalsa.git
tinyalsa-config:= make clean
tinyalsa-install:=$(INSTALL) -DR libtinyalsa.so /usr/lib/libtinyalsa.so
tinyalsa-install+=&& $(INSTALL) -DR include/sound/asound.h /usr/include/sound/asound.h
tinyalsa-install+=&& $(INSTALL) -DR include/tinyalsa/asoundlib.h /usr/include/tinyalsa/asoundlib.h
tinyalsa-install+=&& $(INSTALL) -DR tinymix /usr/bin/tinymix
tinyalsa-install+=&& $(INSTALL) -DR tinyplay /usr/bin/tinyplay
tinyalsa-install+=&& $(INSTALL) -DR tinycap /usr/bin/tinycap
tinyalsa-install+=&& $(INSTALL) -DR tinypcminfo /usr/bin/tinypcminfo

alsa-version:=1.0.27
alsa-lib-version:=$(alsa-version)
subproject-$(CONFIG_ALSA)+=alsa-lib
alsa-lib-url:=ftp://ftp.alsa-project.org/pub/lib/alsa-lib$(alsa-lib-version:%=-%).tar.bz2
alsa-lib-git:=git://git.alsa-project.org/alsa-lib.git
alsa-lib-builddir:=y

alsa-utils-version:=$(alsa-version)
subproject-$(CONFIG_ALSA)+=alsa-utils
alsa-utils-url:=ftp://ftp.alsa-project.org/pub/utils/alsa-utils$(alsa-utils-version:%=-%).tar.bz2
alsa-utils-configure-arguments=--disable-alsamixer --disable-xmlto --disable-alsatest
alsa-utils-builddir:=y

alsa-tools-version:=$(alsa-version)
subproject-$(CONFIG_ALSA_TOOLS)+=alsa-tools
alsa-tools-url:=ftp://ftp.alsa-project.org/pub/tools/alsa-tools$(alsa-tools-version:%=-%).tar.bz2

alsa-plugins-version:=$(alsa-version)
subproject-$(CONFIG_ALSA)+=alsa-plugins
alsa-plugins-url:=ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins$(alsa-plugins-version:%=-%).tar.bz2
alsa-plugins-builddir:=y

pulseaudio-version:=4.0
subproject-$(CONFIG_PULSEAUDIO)+=pulseaudio
pulseaudio-url:=http://freedesktop.org/software/pulseaudio/releases/pulseaudio$(pulseaudio-version:%=-%).tar.xz
pulseaudio-git:=http://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git
pulseaudio-configure-arguments=--disable-x11 --disable-systemd
pulseaudio-builddir:=y
