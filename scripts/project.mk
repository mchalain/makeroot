# ==========================================================================
# create directories on the target system

flags_extend=$(if $(filter arm, $(ARCH)), $(if $(filter y,$(THUMB)),-mthumb,-marm) -march=$(SUBARCH) -mfloat-abi=$(if $(filter y,$(HFP)),hard,soft))
CFLAGS:=--sysroot=$(sysroot) $(flags_extend) $(GCC_FLAGS)
LDFLAGS:=--sysroot=$(sysroot) -Wl,-rpath=$(sysroot)/lib -Wl,-rpath=$(sysroot)/usr/lib $(flags_extend) $(GCC_FLAGS)
export CFLAGS LDFLAGS

PKG_CONFIG_LIBDIR=$(objtree)/usr/lib/pkgconfig
PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR=$(sysroot)
export PKG_CONFIG_LIBDIR PKG_CONFIG_PATH PKG_CONFIG_SYSROOT_DIR

config_shipped:=.config_shipped.prj

quiet_cmd_configure-project = CONFIGURE $*
cmd_configure-project = \
	$(eval sprj-defconfig = $($(notdir $*)-defconfig)) \
	$(eval sprj-mkconfig = $($(notdir $*)-mkconfig)) \
	$(eval sprj-config = $($(notdir $*)-config)) \
	$(eval sprj-makeflags = $($(notdir $*)-makeflags)) \
	$(if $(sprj-config), $(if $(wildcard  $(sprj-src)/$(config_shipped)), ,cd $(sprj-src) && $(sprj-config) ), \
	$(if $(sprj-mkconfig), $(if $(wildcard  $(sprj-src)/$(config_shipped)), ,$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkconfig) configure ), \
	$(if $(sprj-defconfig), $(if $(wildcard  $(sprj-src)/$(config_shipped)), ,cp $(sprj-defconfig) $(sprj-src)/.config; $(MAKE) $(sprj-makeflags) -C $(sprj-src) MAKEFLAGS= silentoldconfig))))

quiet_cmd_build-project = BUILD $*
cmd_build-project = \
	$(eval sprj-build = $($(notdir $*)-build)) \
	$(eval sprj-makeflags = $($(notdir $*)-makeflags)) \
	$(if $(sprj-build), $(sprj-build), \
	$(if $(sprj-mkbuild), $(if $(wildcard  $(sprj-src)/$(build_shipped)), ,$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkconfig) build), \
	$(MAKE) $(sprj-makeflags) MAKEFLAGS= -C $(sprj-src) $(target); ))

quiet_cmd_install-project = INSTALL $*
cmd_install-project = \
	$(eval sprj-install = $($(notdir $*)-install)) \
	$(eval sprj-makeflags = $($(notdir $*)-makeflags)) \
	$(if $(sprj-install), $(sprj-install), \
	$(if $(sprj-mkinstall), $(if $(wildcard  $(sprj-src)/$(build_shipped)), ,$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkconfig) install), \
	$(MAKE)  $(sprj-makeflags) MAKEFLAGS= PREFIX=$(objtree) DESTDIR=$(objtree) -C $(sprj-src) install))

$(sort $(subproject-target)):  $(obj)/.%.prj: $($(notdir $@)-defconfig)
	@$(eval sprj-src =  $(addprefix $(src)/,$*$(if $($(notdir $*)-version),-$($(notdir $*)-version)))) \
	$(call cmd,configure-project)
	@$(eval sprj-targets = $($(notdir $*)-build-target)) \
	$(eval sprj-src =  $(addprefix $(src)/,$*$(if $($(notdir $*)-version),-$($(notdir $*)-version)))) \
	$(if $(sprj-targets), \
		$(foreach target, $(sprj-targets), $(call cmd,build-project)), \
		$(call cmd,build-project))
	@$(call cmd,install-project)
	@touch $@
