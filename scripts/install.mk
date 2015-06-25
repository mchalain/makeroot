# ==========================================================================
# create directories on the target system

quiet_cmd_mkdir = MKDIR $@
cmd_mkdir = $(if $(wildcard $(join $(install-dest)/,$(install-target))), ,mkdir -p $(join $(install-dest)/,$(install-target)))
cmd_mksubdir = cd $(install-dest) && $(cmd_mkdir)

define copydir
	$(foreach d,$(wildcard $(1)*),
		$(if $(wildcard $(dir $(2)/)),,$(Q)mkdir -p $(dir $(2)/))
		$(call copydir,$(d)/,$(2)/$(notdir $(d)))
		$(if $(filter-out %/,$(wildcard $(d)/)),
			$(Q)cp -P $(filter %,$(d)) $(2)/
			$(if $(findstring strip,$(3)), $(CROSS_COMPILE)strip $(2)/$(notdir $(d)))
		)
	)
	$(if $(wildcard $(1)/.),$(if $(wildcard $(dir $(2)/)$(notdir $(1))),,$(Q)mkdir -p $(dir $(2)/)$(notdir $(1))))
endef

cmd_copy = $(Q)cp $(if $(wildcard $(copy)),$(copy),$(join $(srctree)/,$(copy))) $(join $(install-dest)/,$(install-target))
cmd_move = $(Q)mv $(if $(wildcard $(move)),$(move),$(join $(srctree)/,$(move))) $(join $(install-dest)/,$(install-target))
quiet_cmd_link = LINK $(link)
cmd_link = 	$(Q)cd $(install-dest) && ln -sf $(link) $(install-target)
cmd_touch = $(Q)touch $(join $(install-dest)/,$(install-target))
quiet_cmd_generate = GEN $(generate)
cmd_generate = $(Q)mv $(generate) $(join $(install-dest)/,$(install-target))

cmd_chown = $(Q)cd $(install-dest) && chown $(chown) $(install-target)
cmd_chmod = $(Q)cd $(install-dest) && chmod $(chmod) $(install-target)
cmd_strip = $(Q)cd $(install-dest) && strip $(install-target)

quiet_cmd_install = INSTALL $@
define cmd_install
	$(eval install-target = $@)
	$(if $(dir),$(if $(findstring y,$(dir)),
		$(cmd_mkdir),
		$(call copydir,$(join $(srctree)/,$(dir)),$(dir $(join $(install-dest)/,$(install-target),$(findstring y,$(strip))))))
	)
	$(if $(wildcard $(dir $(join $(install-dest)/,$(install-target)))),,$(Q)mkdir -p $(dir $(join $(install-dest)/,$(install-target))))
	$(if $(copy), $(cmd_copy))
	$(if $(move), $(cmd_move))
	$(if $(link), $(cmd_link))
	$(if $(findstring y,$(touch)), $(cmd_touch))
	$(if $(generate), $(cmd_generate))
	$(if $(findstring y,$(strip)), $(cmd_strip))
	$(if $(chmod), $(cmd_chmod))
	$(if $(chown), $(cmd_chown))
endef

install-subdirs:=$(sort $(filter-out $(addsuffix /,$(install-y:%/=%)),$(filter-out ./,$(dir $(install-y)))))
$(install-subdirs): $(rootfs) FORCE
	$(eval install-dest = $(rootfs))
	$(if $(wildcard $(rootfs)/$@),,$(eval install-target = $@) $(call cmd,mkdir))

$(sort $(install-y)): %: $(install-subdirs)
	$(eval install-dest = $(rootfs))
	$(if $(or $(findstring ,$(wildcard $(rootfs)/$@)),$(findstring y,$(force))),$(call multicmd,install))
	$(eval install-dest = $(sysroot))
	$(if $(findstring y,$(install-sysroot)),$(call multicmd,install))

$(sort $(pre-install-y)): %: $(install-subdirs)
	$(eval install-dest = $(rootfs))
	$(if $(and $(wildcard $(rootfs)/$@),$(findstring n,$(force))),,$(call multicmd,install))
	$(eval install-dest = $(sysroot))
	$(if $(findstring y,$(install-sysroot)),$(call multicmd,install))
