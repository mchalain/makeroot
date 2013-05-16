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
ifeq ($(notdir $(CURDIR)),libdrm)
#libdrm need a patch on pthread-stub found from linux from scratch
#this library is useless on linux
configure: FORCE
	sed -e "/pthread-stubs/d" -i configure.ac && \
	autoreconf -fi && \
	./configure CC=$(CROSS_COMPILE:%-=%)-gcc CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" $(DRM_CONFIGURE_OPTIONS) $(STD_CONFIGURE_OPTIONS)
endif

MESA_CONFIGURE_OPTIONS:=
ifeq ($(CONFIG_DRM),y)
egl-platforms:=drm
endif
ifeq ($(CONFIG_WAYLAND),y)
egl-platforms:=$(if $(egl-platforms),$(egl-platforms)$(comma))wayland
endif
ifeq ($(CONFIG_X11),y)
egl-platforms:=$(if $(egl-platforms),$(egl-platforms)$(comma))x11
else
MESA_CONFIGURE_OPTIONS+=--disable-dri --disable-glx
endif
MESA_CONFIGURE_OPTIONS+=--with-egl-platforms="$(egl-platforms)"
ifneq ($(CONFIG_SCREEN_WIDTH),)
MESA_CONFIGURE_OPTIONS+=--with-max-width=$(CONFIG_SCREEN_WIDTH)
endif
ifneq ($(CONFIG_SCREEN_HEIGHT),)
MESA_CONFIGURE_OPTIONS+= --with-max-height==$(CONFIG_SCREEN_HEIGHT)
endif
MESA_CONFIGURE_OPTIONS+=--with-sysroot=$(dir $(CONFIG))/out/target/$(CONFIG_BOARD_NAME:"%"=%)
MESA_CONFIGURE_OPTIONS+=--enable-gles2 --enable-gles1 --enable-gbm
gallium-drivers:=swrast
ifeq ($(CONFIG_EGL_LIMA),Y)
gallium-drivers+=limare
endif
ifeq ($(CONFIG_EGL_FREEDRENO),y)
gallium-drivers+=$(if $(gallium-drivers),$(gallium-drivers)$(comma))freedreno
endif
MESA_CONFIGURE_OPTIONS+= --with-gallium-drivers="$(strip $(gallium-drivers))"
MESA_CONFIGURE_OPTIONS+=$(CONFIG_EGL_MESA_OPTIONS:"%"=%)
ifeq ($(notdir $(CURDIR)),mesa)
configure: FORCE
	autoreconf -fi && \
	./configure PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) CFLAGS="$(CFLAGS) -DMESA_EGL_NO_X11_HEADERS" LDFLAGS="$(LDFLAGS)" $(MESA_CONFIGURE_OPTIONS) $(STD_CONFIGURE_OPTIONS)
endif
build: FORCE
	make
	cp ../config/mesa_builtin_compiler src/glsl/builtin_compiler/builtin_compiler
	make
FORCE:;

