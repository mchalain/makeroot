# ==========================================================================
# create directories on the target system

flags_extend=$(if $(filter arm, $(ARCH)), $(if $(filter y,$(THUMB)),-mthumb,-marm) \
							-march=$(SUBARCH) -mfloat-abi=$(if $(filter y,$(HFP)),hard,soft))
CPPFLAGS:=--sysroot=$(sysroot) -isystem $(sysroot)/usr/include
CFLAGS:=-O
LDFLAGS:= \
	-Wl,-rpath-link=/usr/lib/:/lib/:$(join /lib/,$(TRIPLET)) \
	-Wl,--dynamic-linker=/lib/$(LDSO)
DSOFLAGS:=$(LDFLAGS)
# GCC_FLAGS is defined with the config file
CFLAGS+=$(flags_extend) $(LDFLAGS) $(CPPFLAGS) $(GCC_FLAGS)
CPPFLAGS+=$(GCC_FLAGS)
CXXFLAGS:=$(CFLAGS)
LDFLAGS+=$(flags_extend) $(CPPFLAGS) $(GCC_FLAGS)
CC:=$(if $(wildcard $(sysroot)/gcc.specs),$(toolchain_path)/bin/specs-wrapper-gcc,$(CC))
# when specs file is used, this file is necessary for the link
# LD doesn't support specs file directly, and we have to use CC instead
LD:=$(if $(wildcard $(sysroot)/gcc.specs),$(CC),$(LD))
export CFLAGS CPPFLAGS CXXFLAGS LDFLAGS DSOFLAGS LD

# install-sh is a tool to install binaries and data inside the root directory
# this script can use different applications that we can modify by environment variables
# CHGRPPROG CHMODPROG CHOWNPROG MKDIRPROG MVPROG RMPROG
CPPROG:=$(CROSS_COMPILE)cpp
STRIPPROG:=$(CROSS_COMPILE)strip
INSTALL=$(hostbin:%=%/)install
export STRIPPROG CPPROG

PKG_CONFIG=pkg-config
PKG_CONFIG_LIBDIR:=$(sysroot)/usr/lib/pkgconfig $(hostlib)/pkgconfig
PKG_CONFIG_PATH:=$(sysroot)/usr/lib/pkgconfig:$(hostlib)/pkgconfig
PKG_CONFIG_SYSROOT_DIR:=$(sysroot)
export PKG_CONFIG PKG_CONFIG_LIBDIR PKG_CONFIG_PATH PKG_CONFIG_SYSROOT_DIR

config_shipped:=.config_shipped.prj
build_shipped:=.build_shipped.prj
install_shipped:=.install_shipped.prj

unsetflags:=MAKEFLAGS=
#unsetflags:=

configure-flags:= \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes

configure-cmd:= \
	./configure \
	--host=$(TRIPLET) \
	--target=$(TRIPLET) \
	--build=x86_64-unknown-linux-gnu \
	--prefix=/$(SYSTEM) \
	--sysconfdir=/$(CONFIGDIR)
quiet_cmd_configure-project = CONFIGURE $(sprj)
define cmd_configure-project
	$(eval sprj-makeflags:=$($(sprj)-makeflags))
	$(eval sprj-defconfig = $($(sprj)-defconfig))
	$(eval sprj-mkconfig = $($(sprj)-mkconfig))
	$(eval sprj-config = $($(sprj)-config))
	$(eval sprj-config-opts = $($(sprj)-configure-arguments))
	$(if $(wildcard $(sprj-builddir)),,$(Q)mkdir -p $(sprj-builddir))
	$(if $(sprj-config),
		$(Q)cd $(sprj-builddir) && $(sprj-config),
		$(if $(sprj-mkconfig),
			$(Q)$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkconfig) configure ,
			$(if $(sprj-defconfig),
				$(Q)cp $(sprj-defconfig) $(sprj-src)/.config && $(MAKE) $(unsetflags) $(sprj-makeflags) -C $(sprj-src) silentoldconfig,
				$(if $(wildcard $(sprj-src)/configure),
					$(Q)cd $(sprj-builddir) && $(sprj-makeflags) $(configure-flags) $(srctree)/$(src)/$(notdir $(sprj-src))/$(configure-cmd) $(sprj-config-opts),
					$(if $(wildcard $(sprj-src)/configure.ac),
						$(Q)cd $(sprj-src) && autoreconf --force -i
						$(Q)cd $(sprj-builddir) && $(sprj-makeflags) $(configure-flags) $(srctree)/$(src)/$(notdir $(sprj-src))/$(configure-cmd) $(sprj-config-opts),
						$(Q)echo "no configuration found inside $(sprj-builddir)" && exit 1
					)
				)
			)
		)
	)
endef

quiet_cmd_build-project = BUILD $(sprj) $(target)
define cmd_build-project
	$(eval sprj-makeflags:=$($(sprj)-makeflags))
	$(eval sprj-build = $($(sprj)-build))
	$(if $(sprj-build),
		$(Q)cd $(sprj-builddir) && $(sprj-build),
		$(if $(sprj-mkbuild),
			$(Q)$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-builddir) -f $(srctree)/$(sprj-mkbuild) $(if $(target),$(target),build),
			$(if $(wildcard  $(sprj-builddir)/Makefile),
				$(Q)$(MAKE) -C $(sprj-builddir) $(unsetflags) $(sprj-makeflags) $(target),
				$(if $(wildcard  $(sprj-src)/Makefile),
					$(Q)$(MAKE) -C $(sprj-builddir) -f $(srctree)/$(sprj-src)/Makefile $(unsetflags) $(sprj-makeflags) $(target),
					$(if $(wildcard  $(sprj-src)/Android.mk),
						$(Q)$(call android-tools) && $(MAKE) $(unsetflags) $(sprj-makeflags)  $(android-build)=$(sprj-src)/Android.mk,
						$(Q)echo "no build script found inside $(sprj-builddir)" && exit 1
					)
				)
			)
		)
	)
endef

install_tool=$(addprefix $(hostbin:%=%/),install)
quiet_cmd_install-project = INSTALL $(sprj)
define cmd_install-project
	$(eval sprj-makeflags:=$($(sprj)-makeflags))
	$(eval sprj-install = $($(sprj)-install))
	$(if $(wildcard $(sprj-destdir)),, $(Q)mkdir -p $(sprj-destdir))
	$(if $(sprj-install), 
		$(Q)cd $(sprj-builddir) && $(sprj-install),
		$(if $(sprj-mkinstall),
			$(Q)$(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkinstall) install,
			$(if $(wildcard  $(sprj-builddir)/Makefile),
				$(Q)$(MAKE) -C $(sprj-builddir) $(unsetflags) INSTALL=$(install_tool) DESTDIR=$(sprj-destdir) $(sprj-makeflags) install,
				$(if $(wildcard  $(sprj-src)/Makefile),
					$(Q)$(MAKE) -C $(sprj-builddir) -f $(srctree)/$(sprj-src)/Makefile $(unsetflags) INSTALL=$(install_tool) DESTDIR=$(sprj-destdir) $(sprj-makeflags) install,
					$(Q)echo "no build script found inside $(sprj-builddir)" && exit 1
				)
			)
		)
	)
endef

quiet_cmd_post-install-project = SYSROOT $(sprj)
define cmd_post-install-project
	$(foreach install-target, lib/ $(SYSTEM)/lib/ $(SYSTEM)/include/, \
		$(eval install-dest = $(join $(sysroot)/,$(install-target)))
		$(Q)if [ -d $(join $(sprj-destdir)/,$(install-target)) ]; then cd $(sprj-destdir)/ && $(INSTALL) -DrpP $(install-target) $(install-dest); fi
	)
	$(foreach install-target, lib/ bin/ sbin/ $(SYSTEM)/lib/ $(SYSTEM)/bin/ $(SYSTEM)/sbin/ $(SYSTEM)/libexec/, \
		$(if $$(wildcard $(join $(sprj-destdir)/,$(install-target))) ,
			$(eval install-dest = $(join $(rootfs)/,$(install-target)))
			$(Q)if [ -d $(join $(sprj-destdir)/,$(install-target)) ]; then cd $(sprj-destdir)/ && $(INSTALL) -DrpP $(install-target) $(install-dest); fi
		)
	)
	$(foreach install-target, $(SYSTEM)/share/locale $(SYSTEM)/share/$(sprj) $(CONFIGDIR)/,
		$(if $$(wildcard $(join $(sprj-destdir)/,$(install-target))) ,
			$(eval install-dest = $(join $(rootfs)/,$(install-target)))
			$(Q)if [ -d $(join $(sprj-destdir)/,$(install-target)) ]; then cd $(sprj-destdir)/ && $(INSTALL) -DrpP $(install-target) $(install-dest); fi
		)
	)
endef
#$(src)/%:
#	$(if $(findstring -,$*),$(eval dwl-version=$(lastword $(subst -, ,$*))) $(eval dwl-target=$(firstword $(subst -, ,$*))))
#	@$(call cmd_download,$(dwl-target),$(dwl-version));

define do-project
$(join $(src)/,$(if $(filter-out git hg cvs,$($(1)-version)),$(1)-$($(1)-version),$(1))):
	$(Q)$(call cmd_download,$(1),$($(1)-version))

.SECONDEXPANSION:
.PHONY:$(1)-configure
$(1)-configure: $($(1)-dependances)
	$(Q)$(MAKE) $(build)=$(obj) sprj=$(1) configure-project

.SECONDEXPANSION:
.PHONY:$(1)-build
$(1)-build: $(1)-configure
	$(eval sprj-targets:=$(if $($(1)-targets),$($(1)-targets),all))
	$(foreach target, $(sprj-targets),
		$(Q)$(MAKE) $(build)=$(obj) sprj=$(1) target=$(target) build-project )

$(join $(packagesdir)/,$(if $(filter-out git hg cvs,$($(1)-version)),$(1)-$($(1)-version),$(1))): $(1)-build
	$(Q)$(MAKE) $(build)=$(obj) sprj=$(1) install-project

.SECONDEXPANSION:
.PHONY:$(1)
$(1): $(eval sprj-destdir:=$(join $(packagesdir)/,$(if $(filter-out git hg cvs,$($(1)-version)),$(1)-$($(1)-version),$(1))))
$(1): $(packagesdir) $(sysroot) $(rootfs) $(bootfs) $(if $(wildcard $(sprj-destdir)),,$(sprj-destdir))
	$(Q)$(MAKE) $(build)=$(obj) sprj=$(1) force-install=$(force-install) post-install-project
endef
$(foreach subproject, $(subproject-y),$(eval $(call do-project,$(subproject))))

.PHONY:post-install-project
post-install-project:
	$(eval sprj-version:=$(filter-out git hg cvs,$($(strip $(sprj)-version))))
	$(eval sprj-destdir:=$(join $(packagesdir)/,$(if $(filter-out git hg cvs,$($(sprj)-version)),$(sprj)-$($(sprj)-version),$(sprj))))
	$(if $(wildcard $(sprj-destdir)/.post-install),$(call multicmd,post-install-project))
	$(if $(wildcard $(sprj-destdir)/.post-install),@rm $(sprj-destdir)/.post-install)

.PHONY:install-project
install-project:
	$(eval sprj-version:=$(filter-out git hg cvs,$($(sprj)-version)))
	$(eval sprj-src:=$(firstword $(wildcard $(join $(src)/,$(sprj)-$($(sprj)-version)) $(join $(src)/,$(sprj)))))
	$(eval sprj-builddir:=$(dir $(sprj-src))$(if $(findstring y,$($(sprj)-builddir)),build-)$(notdir $(sprj-src)))
	$(eval sprj-builddir:=$(if $(findstring y,$($(sprj)-builddir)),$(join $(objtree)/build/,$(notdir $(sprj-src))),$(sprj-src)))
	$(eval sprj-destdir:=$(join $(packagesdir)/,$(if $(filter-out git hg cvs,$($(sprj)-version)),$(sprj)-$($(sprj)-version),$(sprj))))
	$(Q)$(call multicmd,install-project)
	@touch $(sprj-destdir)/.post-install

.PHONY:build-project
build-project:
	$(eval sprj-version:=$(filter-out git hg cvs,$($(sprj)-version)))
	$(eval sprj-src:=$(firstword $(wildcard $(join $(src)/,$(sprj)-$($(sprj)-version)) $(join $(src)/,$(sprj)))))
	$(eval sprj-builddir:=$(dir $(sprj-src))$(if $(findstring y,$($(sprj)-builddir)),build-)$(notdir $(sprj-src)))
	$(eval sprj-builddir:=$(if $(findstring y,$($(sprj)-builddir)),$(join $(objtree)/build/,$(notdir $(sprj-src))),$(sprj-src)))
	$(Q)$(call multicmd,build-project)

.PHONY:configure-project
configure-project:
	$(eval sprj-version:=$(filter-out git hg cvs,$($(sprj)-version)))
	$(eval sprj-src:=$(firstword $(wildcard $(join $(src)/,$(sprj)-$($(sprj)-version)) $(join $(src)/,$(sprj)))))
	$(eval sprj-builddir:=$(dir $(sprj-src))$(if $(findstring y,$($(sprj)-builddir)),build-)$(notdir $(sprj-src)))
	$(eval sprj-builddir:=$(if $(findstring y,$($(sprj)-builddir)),$(join $(objtree)/build/,$(notdir $(sprj-src))),$(sprj-src)))
	$(Q)$(call multicmd,configure-project)
