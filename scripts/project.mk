# ==========================================================================
# create directories on the target system

flags_extend=$(if $(filter arm, $(ARCH)), $(if $(filter y,$(THUMB)),-mthumb,-marm) -march=$(SUBARCH) -mfloat-abi=$(if $(filter y,$(HFP)),hard,soft))
CFLAGS:=--sysroot=$(sysroot) $(flags_extend) $(GCC_FLAGS)
CPPFLAGS:=$(CFLAGS)
CXXFLAGS:=$(CFLAGS)
LDFLAGS:=--sysroot=$(sysroot) -Wl,-rpath-link=$(sysroot)/usr/lib/:$(sysroot)/lib/:$(join $(sysroot)/lib/,$(CROSS_COMPILE:%-=%)) $(flags_extend) $(GCC_FLAGS)
DSOFLAGS:=$(LDFLAGS)
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

configure-cmd:= \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes \
	PKG_CONFIG_PATH=$(sysroot)/usr/lib/pkgconfig:$(hostlib)/pkgconfig \
	PKG_CONFIG_SYSROOT_DIR=$(sysroot) \
	./configure \
	--host=$(CROSS_COMPILE:%-=%) \
	--target=$(CROSS_COMPILE:%-=%) \
	--prefix=/usr \
	--sysconfdir=/etc
quiet_cmd_configure-project = CONFIGURE $(sprj)
cmd_configure-project = \
	$(eval sprj-makeflags:=$($(sprj)-makeflags)) \
	$(eval sprj-defconfig = $($(sprj)-defconfig)) \
	$(eval sprj-mkconfig = $($(sprj)-mkconfig)) \
	$(eval sprj-config = $($(sprj)-config)) \
	$(eval sprj-config-opts = $($(sprj)-configure-arguments)) \
	$(if $(sprj-config), cd $(sprj-src) && $(sprj-config), \
	$(if $(sprj-mkconfig), $(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkconfig) configure , \
	$(if $(sprj-defconfig), cp $(sprj-defconfig) $(sprj-src)/.config && $(MAKE) $(sprj-makeflags) -C $(sprj-src) MAKEFLAGS= silentoldconfig, \
	$(if $$(wildcard $(sprj-src)/configure), cd $(sprj-src) && $(configure-cmd) $(sprj-config-opts), \
	$(if $$(wildcard $(sprj-src)/configure.ac), cd $(sprj-src) && autoreconf --force -i && $(configure-cmd) $(sprj-config-opts), \
	echo "no configuration found inside $(sprj-src)" && exit 1) ) ) ) )

quiet_cmd_build-project = BUILD $(sprj) $(target)
cmd_build-project = \
	$(eval sprj-makeflags:=$($(sprj)-makeflags)) \
	$(eval sprj-build = $($(sprj)-build)) \
	$(if $(sprj-build), cd $(sprj-src) && $(sprj-build), \
	$(if $(sprj-mkbuild), $(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkbuild) $(if $(target),$(target),build), \
	$(if $$(wildcard  $(sprj-src)/Makefile), $(MAKE) $(sprj-makeflags) MAKEFLAGS= -C $(sprj-src) $(target), \
	$(if $$(wildcard  $(sprj-src)/Android.mk), $(call android-tools) && $(MAKE) $(sprj-makeflags) MAKEFLAGS= $(android-build)=$(sprj-src)/Android.mk, \
	echo "no build script found inside $(sprj-src)" && exit 1) )))

install_tool=$(addprefix $(hostbin:%=%/),install)
quiet_cmd_install-project = INSTALL $(sprj)
cmd_install-project = \
	$(eval sprj-makeflags:=$($(sprj)-makeflags)) \
	$(eval sprj-destdir = $(packagesdir)/$(sprj)$($(sprj)-version:%=-%)) \
	$(eval sprj-install = $($(sprj)-install)) \
	$(if $(sprj-install), cd $(sprj-src) && $(sprj-install), \
	$(if $(sprj-mkinstall), $(MAKE) $(sprj-makeflags) CONFIG=$(srctree)/$(CONFIG_FILE) -C $(sprj-src) -f $(srctree)/$(sprj-mkinstall) install, \
	$(if $$(wildcard  $(sprj-src)/Makefile), $(MAKE)  $(sprj-makeflags) INSTALL=$(install_tool) MAKEFLAGS= PREFIX=$(sprj-destdir) DESTDIR=$(sprj-destdir) DSTROOT=$(sprj-destdir) -C $(sprj-src) install, \
	echo "no build script found inside $(sprj-src)" && exit 1)))

cmd_post-install-project = \
	$(eval sprj-destdir = $(packagesdir)/$(sprj)$($(sprj)-version:%=-%)) \
	$(foreach install-target, lib/ usr/lib/ usr/include, \
		echo install-target $(addprefix $(sprj-destdir)/,$(install-target)) &&\
		$(if $(wildcard $(addprefix $(sprj-destdir)/,$(install-target))), \
			$(eval install-dest = $(sysroot)) \
			$(eval copy = $(addprefix $(sprj-destdir)/,$(install-target)/*)) \
			echo copy $(copy) to $(install-dest)/$(install-target) && \
			$(call cmd,install) &&)) \
	$(foreach install-target, lib/ bin/ usr/lib/ usr/bin/ usr/libexec/, \
		$(if $(wildcard $(addprefix $(sprj-destdir)/,$(install-target))), \
			$(eval install-dest = $(rootfs)) \
			$(eval copy = $(addprefix $(sprj-destdir)/,$(install-target)/*)) \
			echo copy $(copy) to $(install-dest)/$(install-target) \
			$(call cmd,install) &&)) \
	echo done

#$(src)/%:
#	$(if $(findstring -,$*),$(eval dwl-version=$(lastword $(subst -, ,$*))) $(eval dwl-target=$(firstword $(subst -, ,$*))))
#	@$(call cmd_download,$(dwl-target),$(dwl-version));

define do-project
.PHONY:$(1)-configure
$(1)-configure: $(sprj-src)
	$(eval sprj:=$(1))
	$(eval sprj-version:=$($(strip $(1)-version)))
	$(eval sprj-src:=$(if $($(strip $(1)-version)),$(join $(src)/,$(strip $(1)-$($(strip $(1)-version)))),$(join $(src)/,$(1))))
	@$(call cmd,configure-project)

.SECONDEXPANSION:
.PHONY:$(1)-build
$(1)-build: $(1)-configure
	$(eval sprj:=$(1))
	$(eval sprj-version:=$($(strip $(1)-version)))
	$(eval sprj-src:=$(if $($(strip $(1)-version)),$(join $(src)/,$(strip $(1)-$($(strip $(1)-version)))),$(join $(src)/,$(1))))
	$(eval sprj-targets:=$(if $($(strip $(1)-targets)),$($(strip $(1)-targets)),all))
	@$(foreach target, $(if $(sprj-targets),$(sprj-targets),all), $(call cmd,build-project))

.SECONDEXPANSION:
.PHONY:$(1)-install
$(1)-install: $(1)-build
	$(eval sprj:=$(1))
	$(eval sprj-version:=$($(strip $(1)-version)))
	$(eval sprj-src:=$(if $($(strip $(1)-version)),$(join $(src)/,$(strip $(1)-$($(strip $(1)-version)))),$(join $(src)/,$(1))))
	@$(call cmd,install-project)
	@$(call cmd_post-install-project)

.SECONDEXPANSION:
.PHONY:$(1)
$(1): $(if $(wildcard $(addprefix $(obj)/.,$(1).prj)),,$(1)-install)
	@touch $(addprefix $(obj)/.,$(1).prj)
endef
$(foreach subproject, $(subproject-y),$(eval $(call do-project, $(subproject))))
