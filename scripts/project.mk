# ==========================================================================
# create directories on the target system

flags_extend=$(if $(filter arm, $(ARCH)), $(if $(filter y,$(THUMB)),-mthumb,-marm) -march=$(SUBARCH) -mfloat-abi=$(if $(filter y,$(HFP)),hard,soft))
CFLAGS:=--sysroot=$(sysroot) $(flags_extend) $(GCC_FLAGS)
CPPFLAGS:=$(CFLAGS)
CXXFLAGS:=$(CFLAGS)
LDFLAGS:=--sysroot=$(sysroot) -Wl,-rpath-link=$(sysroot)/usr/lib/:$(sysroot)/lib/ $(flags_extend) $(GCC_FLAGS)
DSOFLAGS:=$(LDFLAGS)
export CFLAGS CPPFLAGS CXXFLAGS LDFLAGS DSOFLAGS

# install-sh is a tool to install binaries and data inside the root directory
# this script can use different applications that we can modify by environment variables
# CHGRPPROG CHMODPROG CHOWNPROG MKDIRPROG MVPROG RMPROG
CPPROG:=$(CROSS_COMPILE)cpp
STRIPPROG:=$(CROSS_COMPILE)strip
INSTALL=$(hostbin:%=%/)install
export STRIPPROG CPPROG

PKG_CONFIG_LIBDIR=$(objtree)/usr/lib/pkgconfig
PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR=$(sysroot)
export PKG_CONFIG_LIBDIR PKG_CONFIG_PATH PKG_CONFIG_SYSROOT_DIR

config_shipped:=.config_shipped.prj
build_shipped:=.build_shipped.prj
install_shipped:=.install_shipped.prj

configure-cmd:= \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes \
	./configure \
	--host=$(CROSS_COMPILE:%-=%) \
	--target=$(CROSS_COMPILE:%-=%) \
	--build=x86 \
	--prefix=/usr \
	--sysconfdir=/etc
quiet_cmd_configure-project = CONFIGURE $*
cmd_configure-project = \
	$(eval sprj-defconfig = $($(notdir $*)-defconfig)) \
	$(eval sprj-mkconfig = $($(notdir $*)-mkconfig)) \
	$(eval sprj-config = $($(notdir $*)-config)) \
	$(eval sprj-config-opts = $($(notdir $*)-configure-arguments)) \
	$(if $(sprj-config), $(if $(wildcard  $(sprj-src)/$(config_shipped)), ,cd $(sprj-src) && $(sprj-config) ), \
	$(if $(sprj-mkconfig), $(if $(wildcard  $(sprj-src)/$(config_shipped)), ,$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkconfig) configure ), \
	$(if $(sprj-defconfig), $(if $(wildcard  $(sprj-src)/$(config_shipped)), ,cp $(sprj-defconfig) $(sprj-src)/.config; $(MAKE) $(sprj-makeflags) -C $(sprj-src) MAKEFLAGS= silentoldconfig), \
	$(if $(wildcard $(sprj-src)/configure), cd $(sprj-src) && $(configure-cmd) $(sprj-config-opts), \
	$(if $(wildcard $(sprj-src)/configure.ac), cd $(sprj-src) && autoreconf --force -i && $(configure-cmd) $(sprj-config-opts), echo "no configuration found";) ) ) ) )

quiet_cmd_build-project = BUILD $* $(target)
cmd_build-project = \
	$(eval sprj-build = $($(notdir $*)-build)) \
	$(if $(sprj-build), $(if $(wildcard  $(sprj-src)/$(build_shipped)), ,cd $(sprj-src) && $(sprj-build) ), \
	$(if $(sprj-mkbuild), $(if $(wildcard  $(sprj-src)/$(build_shipped)), ,$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkbuild) $(if $(target), $(target),build)), \
	$(if $(wildcard  $(sprj-src)/Makefile), $(MAKE) $(sprj-makeflags) MAKEFLAGS= -C $(sprj-src) $(target), \
	$(if $(wildcard  $(sprj-src)/Android.mk), $(call android-tools) && $(MAKE) $(sprj-makeflags) MAKEFLAGS= $(android-build)=$(sprj-src)/Android.mk, echo "no build script found";) )))

quiet_cmd_install-project = INSTALL $*
cmd_install-project = \
	$(eval sprj-install = $($(notdir $*)-install)) \
	$(if $(sprj-install), $(if $(wildcard  $(sprj-src)/$(install_shipped)), ,cd $(sprj-src) && $(sprj-install) ), \
	$(if $(sprj-mkinstall), $(if $(wildcard  $(sprj-src)/$(install_shipped)), ,$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkinstall) install), \
	$(if $(wildcard  $(sprj-src)/Makefile), $(MAKE)  $(sprj-makeflags) INSTALL=$(hostbin:%=%/)install MAKEFLAGS= PREFIX=$(objtree) DESTDIR=$(objtree) DSTROOT=$(objtree) -C $(sprj-src) install)))

$(sort $(subproject-target)):  $(obj)/.%.prj: $($(notdir $@)-defconfig)
	$(eval sprj-makeflags = $($(notdir $*)-makeflags))
	$(if $(findstring git,$($(notdir $*)-version)),,$(eval sprj-version=$($(notdir $*)-version)))
	$(eval sprj-src =  $(firstword $(wildcard $(addprefix $(src)/,$*$(sprj-version:%=-%)) $(addprefix $(src)/,$*))))
	@$(call cmd,configure-project)
	$(eval sprj-targets = $($(notdir $*)-build-target))
	@$(if $(sprj-targets), \
		$(foreach target, $(sprj-targets), $(call cmd,build-project)), \
		$(call cmd,build-project))
	@$(call cmd,install-project)
	@touch $@
