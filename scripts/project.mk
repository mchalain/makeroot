# ==========================================================================
# create directories on the target system

flags_extend=$(if $(filter arm, $(ARCH)), $(if $(filter y,$(THUMB)),-mthumb,-marm) \
							-march=$(SUBARCH) -mfloat-abi=$(if $(filter y,$(HFP)),hard,soft))
flags_extend+=--sysroot=$(sysroot) -isystem $(sysroot)/usr/include
CFLAGS:=-O
LDFLAGS:= \
	-Wl,-rpath-link=/usr/lib/:/lib/:$(join /lib/,$(TRIPLET)) \
	-Wl,--dynamic-linker=/lib/$(LDSO)
DSOFLAGS:=$(LDFLAGS)
# GCC_FLAGS is defined with the config file
CFLAGS+=$(GCC_FLAGS) $(LDFLAGS) $(flags_extend)
CPPFLAGS:=$(CFLAGS)
CXXFLAGS:=$(CFLAGS)
LDFLAGS+=$(GCC_FLAGS) $(flags_extend)
export CFLAGS CPPFLAGS CXXFLAGS LDFLAGS DSOFLAGS

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
	--prefix=/usr \
	--sysconfdir=/etc
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
					$(Q)cd $(sprj-builddir) && $(sprj-makeflags) $(configure-flags) ../$(notdir $(sprj-src))/$(configure-cmd) $(sprj-config-opts),
					$(if $(wildcard $(sprj-src)/configure.ac),
						$(Q)echo coucou
						$(Q)cd $(sprj-src) && autoreconf --force -i
						$(Q)cd $(sprj-builddir) && $(sprj-makeflags) $(configure-flags) ../$(notdir $(sprj-src))/$(configure-cmd) $(sprj-config-opts),
						$(Q)echo "no configuration found inside $(sprj-src)" && exit 1
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
				$(if $(wildcard  $(sprj-src)/Android.mk),
					$(Q)$(call android-tools) && $(MAKE) $(unsetflags) $(sprj-makeflags)  $(android-build)=$(sprj-src)/Android.mk,
					$(Q)echo "no build script found inside $(sprj-src)" && exit 1
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
				$(Q)echo "no build script found inside $(sprj-src)" && exit 1
			)
		)
	)
endef

quiet_cmd_post-install-project = SYSROOT $(sprj)
define cmd_post-install-project
	$(foreach install-target, lib/ usr/lib/ usr/include/, \
		$(eval install-dest = $(join $(sysroot)/,$(install-target)))
		$(Q)if [ -d $(join $(sprj-destdir)/,$(install-target)) ]; then cd $(sprj-destdir)/ && $(INSTALL) -DrpP $(install-target) $(install-dest); fi
	)
	$(foreach install-target, lib/ bin/ sbin/ usr/lib/ usr/bin/ usr/sbin/ usr/libexec/, \
		$(if $$(wildcard $(join $(sprj-destdir)/,$(install-target))) ,
			$(eval install-dest = $(join $(rootfs)/,$(install-target)))
			$(Q)if [ -d $(join $(sprj-destdir)/,$(install-target)) ]; then cd $(sprj-destdir)/ && $(INSTALL) -DrpP $(install-target) $(install-dest); fi
		)
	)
	$(foreach install-target, usr/share/locale usr/share/$(sprj),
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
	$(eval sprj-destdir:=$(join $(packagesdir)/,$(if $(filter-out git hg cvs,$($(sprj)-version)),$(sprj)-$($(sprj)-version),$(sprj))))
	$(Q)$(call multicmd,install-project)
	@touch $(sprj-destdir)/.post-install

.PHONY:build-project
build-project:
	$(eval sprj-version:=$(filter-out git hg cvs,$($(sprj)-version)))
	$(eval sprj-src:=$(firstword $(wildcard $(join $(src)/,$(sprj)-$($(sprj)-version)) $(join $(src)/,$(sprj)))))
	$(eval sprj-builddir:=$(dir $(sprj-src))$(if $(findstring y,$($(sprj)-builddir)),build-)$(notdir $(sprj-src)))
	$(Q)$(call multicmd,build-project)

.PHONY:configure-project
configure-project:
	$(eval sprj-version:=$(filter-out git hg cvs,$($(sprj)-version)))
	$(eval sprj-src:=$(firstword $(wildcard $(join $(src)/,$(sprj)-$($(sprj)-version)) $(join $(src)/,$(sprj)))))
	$(eval sprj-builddir:=$(dir $(sprj-src))$(if $(findstring y,$($(sprj)-builddir)),build-)$(notdir $(sprj-src)))
	$(Q) echo $(sprj) $($(sprj)-version) $(linaro-version)
	$(Q)$(call multicmd,configure-project)
