# Subdirectories we need to descend into

subdir-ym	:= $(subdir-y) $(subdir-m)

PHONY += $(subdir-ym)
$(subdir-ym):
	$(Q)$(MAKE) $(build)=$@ $(target)

