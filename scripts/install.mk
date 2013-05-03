# ==========================================================================
# create directories on the target system

quiet_cmd_mkdir = MKDIR $@
cmd_mkdir = $(if $(wildcard $(install-target)), ,mkdir -p $(install-target))

cmd_copy = cp -r $(copy) $(install-target)
cmd_move = mv $(move) $(install-target)
quiet_cmd_link = LINK $(link)
cmd_link = ln -s $(link) $(install-target)
cmd_touch = touch $(install-target)

cmd_chown = chown $(chown) $(install-target)
cmd_chmod = chmod $(chmod) $(install-target)

quiet_cmd_install = INSTALL $@
cmd_install = $(eval install-target = $(addprefix $(objtree)/,$@)) \
$(if $(findstring y,$(dir)), $(cmd_mkdir), $(if $(move), $(cmd_move), $(if $(copy), $(cmd_copy), $(if $(link), $(cmd_link), $(if $(findstring y,$(touch)), $(cmd_touch)))))) \
$(if $(chmod), ; $(cmd_chmod)$(if $(chown), ; $(cmd_chown)))

$(sort $(install-y)): $(filter-out $(sort $(install-y)), $(sort $(dir $(install-y))))
	@$(call cmd,install)

$(filter-out $(sort $(install-y)), $(sort $(dir $(install-y)))):
	@$(eval install-target = $(addprefix $(objtree)/,$@)) \
	$(call cmd,mkdir)
