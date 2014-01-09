ffmpeg-version=2.1.1
subproject-$(CONFIG_FFMPEG)+=ffmpeg
ffmpeg-url=http://ffmpeg.org/releases/ffmpeg-$(ffmpeg-version).tar.bz2
ffmpeg-git=git://source.ffmpeg.org/ffmpeg.git ffmpeg
ffmpeg-config:=./configure --enable-cross-compile --cross-prefix=$(CROSS_COMPILE:%-=%)- --sysroot=$(sysroot)
ffmpeg-config+=--arch=$(CONFIG_ARCH) --target-os=linux --target-path=$(objtree)
ffmpeg-config+=--prefix=/usr --enable-shared --disable-doc
# currently neon optimization is not compatible with shared libraries
#ffmpeg-config+=--disable-neon
ifeq ($(CONFIG_PULSEAUDIO),y)
ffmpeg-config+=--enable-libpulse
endif
ifeq ($(CONFIG_VORBIS),y)
ffmpeg-config+=--enable-libvorbis --enable-libtheora 
endif
ifeq ($(CONFIG_TWOLAME),y)
ffmpeg-config+=--enable-libtwolame
endif
ifeq ($(CONFIG_ASS_SUBTITLE),y)
ffmpeg-config+=--enable-libass
endif
ifeq ($(CONFIG_BLURAY),y)
ffmpeg-config+=--enable-libbluray
endif
ifeq ($(CONFIG_FAAC),y)
ffmpeg-config+=--enable-libfaac
endif
