comma   := ,

include $(CONFIG)
STD_CONFIGURE_OPTIONS:=--prefix=/usr --includedir=/usr/include --host=$(CROSS_COMPILE:%-=%) --target=$(CROSS_COMPILE:%-=%)

all: configure

DRM_CONFIGURE_OPTIONS:=

DRM_CONFIGURE_OPTIONS+=--with-sysroot=$(dir $(CONFIG))/out/target/$(CONFIG_BOARD_NAME:"%"=%)
#DRM_CONFIGURE_OPTIONS+=--with-kernel-source=$(dir $(CONFIG))/kernel/linux$(CONFIG_KERNEL_VERSION:"%"=-%)
DRM_CONFIGURE_OPTIONS+=--with-kernel-source=$(dir $(CONFIG))/kernel/linux-linaro-tracking
ifneq ($(CONFIG_GPU_INTEL),y)
DRM_CONFIGURE_OPTIONS+=--disable-intel
endif
ifneq ($(CONFIG_GPU_RADEON),y)
DRM_CONFIGURE_OPTIONS+=--disable-radeon
endif
ifneq ($(CONFIG_GPU_NOUVEAU),y)
DRM_CONFIGURE_OPTIONS+=--disable-nouveau
endif
ifneq ($(CONFIG_GPU_NOUVEAU),y)
DRM_CONFIGURE_OPTIONS+=--disable-vmgfx
endif
ifeq ($(CONFIG_DEV_UDEV),y)
DRM_CONFIGURE_OPTIONS+=--enable-udev
endif
ifeq ($(CONFIG_EGL_FREEDRENO),y)
DRM_CONFIGURE_OPTIONS+=--enable-freedreno-experimental-api
endif
.PHONY+=configure
drm=drm
ifeq ($(findstring $(drm), $(notdir $(CURDIR))),$(drm))
#libdrm need a patch on pthread-stub found from linux from scratch
#this library is useless on linux
configure: FORCE
	$(Q) sed -e "/pthread-stubs/d" -i configure.ac
	$(Q)$(if $(wildcard configure),,autoreconf --force -v --install)
	$(Q) ./configure CC=$(CROSS_COMPILE:%-=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" $(DRM_CONFIGURE_OPTIONS) $(STD_CONFIGURE_OPTIONS)
endif

CAIRO_CONFIGURE_OPTIONS:=
ifeq ($(CONFIG_FREETYPE),y)
CAIRO_CONFIGURE_OPTIONS+=FREETYPE_CFLAGS="-I/usr/include/freetype2/"
endif
ifeq ($(CONFIG_EGL),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-glesv2
endif
ifeq ($(CONFIG_GL),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-gl 
endif
ifeq ($(CONFIG_DRM),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-drm
endif
ifeq ($(CONFIG_DIRECTFB),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-directfb
endif
ifeq ($(CONFIG_QT_GUI),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-qt
endif
ifeq ($(CONFIG_EXPAT),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-xml
endif
ifeq ($(CONFIG_X11),y)
CAIRO_CONFIGURE_OPTIONS+=--enable-xlib
endif
ifeq ($(CONFIG_X11_XCB),y)
CAIRO_CONFIGURE_OPTIONS+= --enable-xlib-xcb  --enable-xcb
endif
ifeq ($(findstring cairo, $(notdir $(CURDIR))),cairo)
configure: FORCE
	$(Q)$(if $(wildcard configure),,autoreconf --force -v --install)
	$(Q) ./configure CFLAGS="$(CFLAGS) -I$(objtree)/usr/include/pixman-1 -DMESA_EGL_NO_X11_HEADERS" LDFLAGS="$(LDFLAGS)" --prefix=/usr --includedir=/usr/include --host=$(CROSS_COMPILE:%-=%) $(CAIRO_CONFIGURE_OPTIONS)
endif

MESA_CONFIGURE_OPTIONS:=
ifeq ($(CONFIG_DRM),y)
egl-platforms:=drm
MESA_CONFIGURE_OPTIONS+=--enable-dri --enable-gbm --with-driver=dri
else
MESA_CONFIGURE_OPTIONS+=--disable-dri
endif
ifeq ($(CONFIG_WAYLAND),y)
egl-platforms:=$(if $(egl-platforms),$(egl-platforms)$(comma))wayland
endif
ifeq ($(CONFIG_X11),y)
egl-platforms:=$(if $(egl-platforms),$(egl-platforms)$(comma))x11
else
MESA_CONFIGURE_OPTIONS+=--disable-glx
endif
MESA_CONFIGURE_OPTIONS+=--with-egl-platforms="$(egl-platforms)"
ifneq ($(CONFIG_SCREEN_WIDTH),)
MESA_CONFIGURE_OPTIONS+=--with-max-width=$(CONFIG_SCREEN_WIDTH)
endif
ifneq ($(CONFIG_SCREEN_HEIGHT),)
MESA_CONFIGURE_OPTIONS+= --with-max-height==$(CONFIG_SCREEN_HEIGHT)
endif
MESA_CONFIGURE_OPTIONS+=--with-sysroot=$(dir $(CONFIG))/out/target/$(CONFIG_BOARD_NAME:"%"=%)
MESA_CONFIGURE_OPTIONS+=--enable-gles2 --enable-gles1
gallium-drivers:=swrast
dri-drivers:=swrast
ifeq ($(CONFIG_EGL_FREEDRENO),y)
gallium-drivers+=$(if $(gallium-drivers),$(gallium-drivers)$(comma))freedreno
endif
MESA_CONFIGURE_OPTIONS+= --with-gallium-drivers="$(strip $(gallium-drivers))"  --with-dri-drivers="$(strip $(dri-drivers))"
MESA_CONFIGURE_OPTIONS+=$(CONFIG_EGL_MESA_OPTIONS:"%"=%)
mesa=Mesa
ifeq ($(findstring $(mesa), $(notdir $(CURDIR))),$(mesa))
configure: FORCE
	$(Q)$(if $(wildcard configure),,autoreconf --force -v --install)
	$(Q) ./configure PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) CFLAGS="$(CFLAGS) -DMESA_EGL_NO_X11_HEADERS -I/usr/include/drm" CXXFLAGS="$(CFLAGS) -DMESA_EGL_NO_X11_HEADERS -I/usr/include/drm" LDFLAGS="$(LDFLAGS) -Wl,-I$(objtree)/lib/ld-linux-armhf.so.3" $(MESA_CONFIGURE_OPTIONS) $(STD_CONFIGURE_OPTIONS)
build: FORCE
	$(Q)make
	$(Q)cp ../config/mesa_builtin_compiler src/glsl/builtin_compiler/builtin_compiler
	$(Q)make
FORCE:;
endif

FORCE:;
