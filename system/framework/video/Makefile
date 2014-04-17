xvidcore-version:=
subproject-$(CONFIG_FW_VIDEO_XVID)+=xvidcore
xvidcore-url:=http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.bz2
xvidcore-cvs:=pserver:anonymous@cvs.xvid.org:/xvid
xvidcore-config:=cd build/generic && ./configure --prefix=/usr --host=$(CROSS_COMPILE:%-=%)
xvidcore-build:=cd build/generic && make
xvidcore-install:=cd build/generic && make DESTDIR=$(packagesdir)/xvidcore install

x264-version:=snapshot-20140414-2245-stable
subproject-$(CONFIG_FW_VIDEO_X264)+=x264
x264-git:=git://git.videolan.org/x264
x264-url:=ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-$(x264-version).tar.bz2
x264-configure-arguments:=--enable-static --enable-shared
x264-makeflags:="AS=$(CROSS_COMPILE:%-=%)-gcc"

libaacplus-version:=2.0.2
subproject-$(CONFIG_FW_AUDIO_AACPLUS)+=libaacplus
libaacplus-url:=http://217.20.164.161/~tipok/aacplus/libaacplus-2.0.2.tar.gz

ffmpeg-version=2.1.1
subproject-$(CONFIG_FW_VIDEO_FFMPEG)+=ffmpeg
ffmpeg-url=http://ffmpeg.org/releases/ffmpeg-$(ffmpeg-version).tar.bz2
ffmpeg-git=git://source.ffmpeg.org/ffmpeg.git ffmpeg
ffmpeg-config:=./configure --enable-cross-compile --cross-prefix=$(CROSS_COMPILE:%-=%)- --sysroot=$(sysroot)
ffmpeg-config+=--arch=$(CONFIG_ARCH:"%"=%) --target-os=linux --cpu=$(CONFIG_SUBARCH:"%"=%)
ffmpeg-config+=--prefix=/usr --enable-shared --disable-doc --disable-stripping --extra-libs=-ldl
ffmpeg-config+=--enable-gpl --enable-version3 --enable-nonfree
# currently neon optimization is not compatible with shared libraries
#ffmpeg-config+=--disable-neon
ifeq ($(CONFIG_PULSEAUDIO),y)
ffmpeg-config+=--enable-libpulse
endif
ifeq ($(CONFIG_FW_VIDEO_XVID),y)
ffmpeg-config+=--enable-libxvid
endif
ifeq ($(CONFIG_FW_VIDEO_X264),y)
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
ifeq ($(CONFIG_FW_AUDIO_AACPLUS),y)
ffmpeg-config+=--enable-libaacplus
endif
ifeq ($(CONFIG_PULSEAUDIO),y)
ffmpeg-config+=--enable-libpulse
endif
