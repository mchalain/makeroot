xvidcore-version:=$(CONFIG_FW_VIDEO_XVID_VERSION)
subproject-$(CONFIG_FW_VIDEO_XVID_SP)+=xvidcore
xvidcore-url:=http://downloads.xvid.org/downloads/xvidcore-$(xvidcore-version).tar.bz2
xvidcore-cvs:=pserver:anonymous@cvs.xvid.org:/xvid
xvidcore-config:=cd build/generic && ./configure --prefix=/usr --host=$(TRIPLET)
xvidcore-build:=cd build/generic && make
xvidcore-install:=cd build/generic && make DESTDIR=$(packagesdir)/xvidcore$(xvidcore-version:%=-%) install

x264-version:=$(CONFIG_FW_VIDEO_X264_VERSION)
subproject-$(CONFIG_FW_VIDEO_X264_SP)+=x264
x264-git:=git://git.videolan.org/x264
x264-url:=ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-$(x264-version).tar.bz2
x264-configure-arguments:=--cross-prefix=$(CROSS_COMPILE)
x264-configure-arguments+=--enable-static --enable-shared --enable-pic
x264-configure-arguments+=--system-libx264 --disable-gpl
x264-makeflags:=AS=$(CROSS_COMPILE:%-=%)-gcc

libaacplus-version:=$(CONFIG_FW_AUDIO_AACPLUS_VERSION)
subproject-$(CONFIG_FW_AUDIO_AACPLUS_SP)+=libaacplus
libaacplus-url:=http://217.20.164.161/~tipok/aacplus/libaacplus-2.0.2.tar.gz

ffmpeg-version=$(CONFIG_FW_VIDEO_FFMPEG_VERSION)
subproject-$(CONFIG_FW_VIDEO_FFMPEG_SP)+=ffmpeg
ffmpeg-url=http://ffmpeg.org/releases/ffmpeg-$(ffmpeg-version).tar.bz2
ffmpeg-git=git://source.ffmpeg.org/ffmpeg.git ffmpeg
ffmpeg-config:=./configure
ffmpeg-config+=--enable-cross-compile --cross-prefix=$(CROSS_COMPILE:%-=%)- --sysroot=$(sysroot)
ffmpeg-config+=--cc="$(CC)"
ffmpeg-config+=--arch=$(ARCH) --target-os=linux --cpu=$(SUBARCH)
ffmpeg-config+=--prefix=/usr --enable-shared --enable-pic --disable-stripping --extra-libs=-ldl
ffmpeg-config+=--enable-gpl --enable-version3 --enable-nonfree --disable-doc
# currently neon optimization is not compatible with shared libraries
#ffmpeg-config+=--disable-neon
ifeq ($(CONFIG_PULSEAUDIO),y)
ffmpeg-config+=--enable-libpulse
endif
ifeq ($(CONFIG_FW_VIDEO_XVID_SP),y)
ffmpeg-config+=--enable-libxvid
endif
ifeq ($(CONFIG_FW_VIDEO_X264_SP),y)
ffmpeg-config+=--enable-libx264
endif
ifeq ($(CONFIG_FW_VIDEO_VORBIS),y)
ffmpeg-config+=--enable-libvorbis --enable-libtheora 
endif
ifeq ($(CONFIG_FW_AUDIO_TWOLAME),y)
ffmpeg-config+=--enable-libtwolame
endif
ifeq ($(CONFIG_ASS_SUBTITLE),y)
ffmpeg-config+=--enable-libass
endif
ifeq ($(CONFIG_BLURAY),y)
ffmpeg-config+=--enable-libbluray
endif
ifeq ($(CONFIG_FW_AUDIO_FAAC),y)
ffmpeg-config+=--enable-libfaac
endif
ifeq ($(CONFIG_FW_AUDIO_AACPLUS_SP),y)
ffmpeg-config+=--enable-libaacplus
endif
