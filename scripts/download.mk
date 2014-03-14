download-copy= | tee $(addprefix $(BUILD_DOWNLOAD_PATH)/, $(notdir $(1)))
download-wget=wget -O - $(1) $(if $(findstring y,$(BUILD_DOWNLOAD_KEEP_COPY)), $(download-copy))
download-directory= cat $(addprefix $(BUILD_DOWNLOAD_PATH)/, $(notdir $(1)))

download-short=$(if $(wildcard $(addprefix $(BUILD_DOWNLOAD_PATH)/, $(notdir $(1)))), $(download-directory), $(download-wget))
quiet_cmd_download-url = DOWNLOAD $* from $($(notdir $*)-url:"%"=%)
cmd_download-url = \
	$(eval url = $($(notdir $*)-url:"%"=%)) \
	$(if $(strip $(findstring .gz, $(suffix $(url))) $(findstring .tgz, $(suffix $(url)))), \
		$(call download-short, $(url)) | tar -xzf - -C $(src), \
	$(if $(findstring .bz2, $(suffix $(url))), \
		$(call download-short, $(url)) | tar -xjf - -C $(src), \
	$(if $(findstring .xz, $(suffix $(url))), \
		$(call download-short, $(url)) | tar -xJf - -C $(src), \
	$(if $(findstring :pserver:,$(url)), \
		cvs -z 9 -d $(url) co $(notdir $*), \
	$(if $($(notdir $*)-git),$(call cmd_download-git),$(error set $($(notdir $*)-url)))))))

quiet_cmd_download-git = DOWNLOAD $* from $($(notdir $*)-git:"%"=%)
cmd_download-git = \
	$(eval url = $($(notdir $*)-git:"%"=%)) \
	git clone $(url) $(src)/$*

quiet_cmd_download-hg = DOWNLOAD $* from $($(notdir $*)-git:"%"=%)
cmd_download-hg = \
	$(eval url = $($(notdir $*)-hg:"%"=%)) \
	hg clone $(url) $(src)/$*

$(download-target): $(obj)/.%.dwl:
	@$(if $(findstring git,$($(notdir $*)-version)), \
		$(eval download-cmd=download-git), \
		$(if $(findstring hg,$($(notdir $*)-version)), \
			$(eval download-cmd=download-hg), \
			$(eval sprj-version=$($(notdir $*)-version)) $(eval download-cmd=download-url))) \
	$(eval sprj-src = $(addprefix $(src)/,$*$(if $(sprj-version),-$(sprj-version)))) \
	$(if $(wildcard  $(sprj-src)), ,$(call cmd,$(download-cmd)))
	@touch $@
