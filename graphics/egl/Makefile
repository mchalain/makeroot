
subproject-$(CONFIG_EGL_SNOWBALL_MALI)+=mali400
#mali400-url=http://igloocommunity.org/download/linaro/mali400/2.1/$(mali400-version).tar.gz
mali400-url=file://./download/mali400_2.1-5.tar.gz

subproject-$(CONFIG_EGL_SUNXI_MALI)+=sunxi-mali
sunxi-mali-git="https://github.com/linux-sunxi/sunxi-mali.git"
sunxi-mali-config=git submodule init && git submodule update
sunxi-mali-makeflags=DESTDIR=$(objtree) ABI=armhf VERSION=r3p1 CC=$(CROSS_COMPILE:%-=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" 

ifeq ($(USE_GIT),y)
mesa:=mesa
else
mesa:=Mesa
endif
Mesa-version=9.1.2
subproject-$(CONFIG_EGL_MESA)+=$(mesa)
mesa-git="git://anongit.freedesktop.org/mesa/mesa.git"
Mesa-url="ftp://ftp.freedesktop.org/pub/mesa/$(mesa-version)/MesaLib$(Mesa-version:%=-%).tar.bz2"
$(mesa)-mkconfig=$(src)/config/mesa.mk
#mesa-config=./autogen.sh CC=$(CROSS_COMPILE:%-=%)-gcc --prefix=$(WLD) --includedir=/usr/include $(CONFIG_MESA_OPTIONS:"%"=%) --host=$(CONFIG_CROSS_COMPILE:"%"=%) 

subproject-$(CONFIG_EGL_VIRTUAL_DRV)+=$(opengl-es-virtual-drv)
opengl-es-virtual-drv-url=https://review.tizen.org/git/?p=adaptation/opengl-es-virtual-drv.git

subproject-$(CONFIG_EGL_LIMA)+=lima
lima-git="git://gitorious.org/lima/lima.git"
lima-makeflags= CC=$(CROSS_COMPILE:%-=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" 

subproject-$(CONFIG_EGL_FREEDRENO)+=freedreno
freedreno-git="https://github.com/freedreno/freedreno.git"
freedreno-makeflags= CC=$(CROSS_COMPILE:%-=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" 

glew-release=2011.10
glew-version=1.7.0$(glew-release:%=-%)-es
subproject-$(CONFIG_EGL_GLEW)+=glew
glew-url="https://launchpad.net/linaro-graphics-misc/$(glew-release)/$(glew-release)/+download/glew$(glew-version:%=-%).tar.bz2"
glew-git="git://gitorious.org/lima/lima.git"
glew-config=./autogen.sh CC=$(CROSS_COMPILE:%-=%)-gcc --prefix=$(WLD) --includedir=/usr/include $(CONFIG_MESA_OPTIONS:"%"=%) --host=$(CONFIG_CROSS_COMPILE:"%"=%) 

