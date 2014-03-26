# ==========================================================================
# create directories on the target system

quiet_cmd_mkdir = MKDIR $@
cmd_mkdir = $(if $(wildcard $(install-target)), ,mkdir -p $(install-target))
cmd_mksubdir = cd $(install-dest) && $(cmd_mkdir)

cmd_copy = cp -r $(copy) $(install-target)
cmd_move = mv $(move) $(install-target)
quiet_cmd_link = LINK $(link)
cmd_link = ln -s $(link) $(install-target)
cmd_touch = touch $(install-target)
quiet_cmd_generate = GEN $(generate)
cmd_generate = mv $(generate) $(install-target)

cmd_chown = chown $(chown) $(install-target)
cmd_chmod = chmod $(chmod) $(install-target)
cmd_strip = strip $(install-target)

quiet_cmd_install = INSTALL $@
cmd_install = $(eval install-target = $@) \
	cd $(install-dest) && \
	$(if $(findstring y,$(dir)), $(cmd_mkdir)) \
	$(if $(move), $(cmd_move)) \
	$(if $(copy), $(cmd_copy)) \
	$(if $(link), $(cmd_link)) \
	$(if $(findstring y,$(touch)), $(cmd_touch)) \
	$(if $(generate), $(cmd_generate)) \
	$(if $(findstring y,$(strip)), && $(cmd_strip)) \
	$(if $(chmod), && $(cmd_chmod)) \
	$(if $(chown), && $(cmd_chown))

$(rootfs):
	mkdir -p $@

install-subdirs:=$(sort $(filter-out $(addsuffix /,$(install-y:%/=%)),$(filter-out ./,$(dir $(install-y)))))
$(install-subdirs): $(rootfs)
	$(eval install-dest = $(rootfs))
	@$(if $(wildcard $(rootfs)/$@),,$(eval install-target = $@) $(call cmd,mksubdir))

$(sort $(install-y)): $(install-subdirs)
	$(eval install-dest = $(rootfs))
	@$(if $(wildcard $(rootfs)/$@),,$(call cmd,install))
