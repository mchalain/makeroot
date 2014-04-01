# ==========================================================================
# create directories on the target system

quiet_cmd_mkdir = MKDIR $@
cmd_mkdir = $(if $(wildcard $(install-target)), ,mkdir -p $(install-target))
cmd_mksubdir = cd $(install-dest) && $(cmd_mkdir)

define copydir
	$(foreach d,$(wildcard $(1)*),
		$(call copyfile,$(d)/,$(2)/$(notdir $(d)))
		$(if $(filter-out %/,$(wildcard $(d)/)),
			$(if $(wildcard $(dir $(2)/)),,$(Q)mkdir -p $(dir $(2)/))
			$(Q)cp $(filter %,$(d)) $(2)/
			$(if $(findstring strip,$(3)), $(CROSS_COMPILE)strip $(2)/$(notdir $(d)))
		)
	)
endef

cmd_copy = $(Q)cp $(join $(srctree)/,$(copy)) $(join $(install-dest)/,$(install-target))
cmd_move = $(Q)mv $(join $(srctree)/,$(move)) $(join $(install-dest)/,$(install-target))
quiet_cmd_link = LINK $(link)
cmd_link = 	$(Q)cd $(install-dest) && ln -s $(link) $(install-target)
cmd_touch = $(Q)cd $(install-dest) && touch $(install-target)
quiet_cmd_generate = GEN $(generate)
cmd_generate = $(Q)mv $(generate) $(install-target)

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
	$(if $(copy), $(cmd_copy))
	$(if $(move), $(cmd_move))
	$(if $(link), $(cmd_link))
	$(if $(findstring y,$(touch)), $(cmd_touch))
	$(if $(generate), $(cmd_generate))
	$(if $(findstring y,$(strip)), $(cmd_strip))
	$(if $(chmod), $(cmd_chmod))
	$(if $(chown), $(cmd_chown))
endef

$(rootfs):
	mkdir -p $@

install-subdirs:=$(sort $(filter-out $(addsuffix /,$(install-y:%/=%)),$(filter-out ./,$(dir $(install-y)))))
$(install-subdirs): $(rootfs)
	$(eval install-dest = $(rootfs))
	$(if $(wildcard $(rootfs)/$@),,$(eval install-target = $@) $(call cmd,mksubdir))

$(sort $(install-y)): $(install-subdirs)
	$(eval install-dest = $(rootfs))
	$(if $(wildcard $(rootfs)/$@),,$(call multicmd,install))
