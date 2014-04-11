# write here your installation customization.
define mkinclude
include $(1)
endef
$(foreach mkfile,$(wildcard $(src)/*.mk),$(eval $(call mkinclude,$(mkfile))))
