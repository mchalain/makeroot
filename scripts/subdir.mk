# Subdirectories we need to descend into

subdir-ym	:= $(sort $(subdir-y) $(subdir-m))

PHONY += $(subdir-ym)
$(subdir-ym):
	$(Q)$(MAKE) $(build)=$@

