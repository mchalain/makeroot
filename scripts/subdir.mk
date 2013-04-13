# Subdirectories we need to descend into

subdir-ym	:= $(sort $(subdir-y) $(subdir-m))

$(subdir-ym):
	@$(if $(wildcard $(src)/$@), ,$(call cmd,download-project))
