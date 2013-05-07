download-copy= | tee $(addprefix $(BUILD_DOWNLOAD_PATH), $(notdir $(1)))
download-wget=wget -O - $(1) $(if $(findstring y,$(BUILD_DOWNLOAD_KEEP_COPY)), $(download-copy))
download-directory= cat $(1)

download=$(if $(wildcard $(addprefix $(BUILD_DOWNLOAD_PATH), $(notdir $(1)))), $(download-directory), $(download-wget))
quiet_cmd_download-project = DOWNLOAD $* from $($(notdir $*)-url:"%"=%)
cmd_download-project = \
	$(eval url = $($(notdir $*)-url:"%"=%)) \
	$(if $(findstring .gz, $(suffix $(url))), \
		$(call download, $(url)) | tar -xzf - -C $(src), \
	$(if $(findstring .bz2, $(suffix $(url))), \
		$(call download, $(url)) | tar -xjf - -C $(src), \
	$(if $(findstring .xz, $(suffix $(url))), \
		$(call download, $(url)) | tar -xJf - -C $(src), \
	$(if $(findstring :pserver:,$(url)), \
		cvs -z 9 -d $(url) co $(notdir $*), \
	$(if $($(notdir $*)-git),$(call cmd_git-project),$(error set $($(notdir $*)-url)))))))

cmd_git-project = \
	$(eval url = $($(notdir $*)-git:"%"=%)) \
	$(if $(findstring .git, $(suffix $(url))), git clone $(url) $(src)/$*)

$(download-target): $(obj)/.%.dwl:
	@$(eval sprj-src = $(addprefix $(src)/,$*$(if $($(notdir $*)-version),-$($(notdir $*)-version)))) \
	$(if $(wildcard  $(sprj-src)), ,$(call cmd,download-project))
	@touch $@
