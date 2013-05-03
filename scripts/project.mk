# ==========================================================================
# create directories on the target system

PKG_CONFIG_LIBDIR=$(objtree)/usr/lib/pkgconfig
PKG_CONFIG_PATH=$(objtree)/usr/lib/pkgconfig
PKG_CONFIG_SYSROOT_DIR=$(sysroot)
CFLAGS=--sysroot=$(sysroot)
LDFLAGS=--sysroot=$(sysroot) -Wl,-rpath=$(sysroot)/lib
export PKG_CONFIG_LIBDIR PKG_CONFIG_PATH PKG_CONFIG_SYSROOT_DIR CFLAGS LDFLAGS

quiet_cmd_configure-project = CONFIGURE $*
cmd_configure-project = \
	$(eval sprj-defconfig = $($(notdir $*)-defconfig)) \
	$(eval sprj-mkconfig = $($(notdir $*)-mkconfig)) \
	$(eval sprj-config = $($(notdir $*)-config)) \
	$(eval sprj-makeflags = $($(notdir $*)-makeflags)) \
	$(if $(sprj-config), $(if $(wildcard  $(sprj-src)/Makefile), ,cd $(sprj-src) && $(sprj-config) ), \
	$(if $(sprj-mkconfig), $(if $(wildcard  $(sprj-src)/Makefile), ,$(MAKE) $(sprj-makeflags) -C $(sprj-src) -f $(sprj-mkconfig)), \
	$(if $(sprj-defconfig), $(if $(wildcard  $(sprj-src)/.config), ,cp $(sprj-defconfig) $(sprj-src)/.config; $(MAKE) $(sprj-makeflags) -C $(sprj-src) MAKEFLAGS= silentoldconfig))))

quiet_cmd_build-project = BUILD $*
cmd_build-project = \
	$(eval sprj-build = $($(notdir $*)-build)) \
	$(eval sprj-makeflags = $($(notdir $*)-makeflags)) \
	$(if $(sprj-build), $(sprj-build), $(MAKE) $(sprj-makeflags) MAKEFLAGS= -C $(sprj-src) $(target); )

quiet_cmd_install-project = INSTALL $*
cmd_install-project = \
	$(eval sprj-install = $($(notdir $*)-install)) \
	$(eval sprj-makeflags = $($(notdir $*)-makeflags)) \
	$(if $(sprj-install), $(sprj-install), $(MAKE)  $(sprj-makeflags) MAKEFLAGS= PREFIX=$(objtree) DESTDIR=$(objtree) -C $(sprj-src) install)

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
